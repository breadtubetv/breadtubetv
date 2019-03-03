package providers

import (
	"encoding/json"
	"fmt"
	"log"
	"net"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"os/user"
	"path"
	"path/filepath"
	"runtime"

	"github.com/breadtubetv/breadtubetv/bake/util"
	"golang.org/x/net/context"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"

	"google.golang.org/api/youtube/v3"
)

const accessJSON = `{
	"installed": {
		"client_id": "660935947237-ajqve9kv3n0nnhonhnc5j638fsfan31o.apps.googleusercontent.com",
		"project_id": "sacred-dahlia-229511",
		"auth_uri": "https://accounts.google.com/o/oauth2/auth",
		"token_uri": "https://oauth2.googleapis.com/token",
		"auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
		"client_secret": "piloG0CTWO7PVlbwX8drp6xU",
		"redirect_uris": ["urn:ietf:wg:oauth:2.0:oob","http://localhost"]
  }
}`

func LoadYoutube() map[string]interface{} {
	return map[string]interface{}{
		"config":         config,
		"channel_import": importChannel,
	}
}

func config() {
	client := getClient(youtube.YoutubeReadonlyScope)

	_, err := youtube.New(client)
	if err != nil {
		log.Fatalf("Error creating YouTube client: %v", err)
	}

	log.Printf("Successfully authenticated and cached credentials.")
}

// FetchDetails returns the YouTube details for a channel
func FetchDetails(channelURL *util.URL) (util.Provider, error) {
	id := path.Base(channelURL.Path)
	category := path.Base(path.Dir(channelURL.Path))

	client := getClient(youtube.YoutubeReadonlyScope)
	service, err := youtube.New(client)
	if err != nil {
		return util.Provider{}, fmt.Errorf("error creating YouTube client: %v", err)
	}

	call := service.Channels.List("snippet,statistics")
	if category == "channel" {
		call = call.Id(id)
	} else {
		call = call.ForUsername(id)
	}
	response, err := call.Do()
	handleError(err, "")

	if len(response.Items) == 0 {
		return util.Provider{}, fmt.Errorf("could not find channel from URL")
	}

	channelName := ""
	channelSubscriberCount := uint64(0)
	for _, item := range response.Items {
		channelName = item.Snippet.Title
		channelSubscriberCount = item.Statistics.SubscriberCount
		break
	}

	return util.Provider{
		Name:        channelName,
		URL:         channelURL,
		Slug:        id,
		Subscribers: channelSubscriberCount,
	}, nil
}

func formatChannelDetails(slug string, channelURL *util.URL) (util.Channel, error) {
	provider, err := FetchDetails(channelURL)
	if err != nil {
		return util.Channel{}, err
	}

	return util.Channel{
		Name:      provider.Name,
		Slug:      slug,
		Providers: map[string]util.Provider{"youtube": provider},
	}, nil
}

func importChannel(slug string, channelURL *util.URL) {
	channelList := util.LoadChannels("../data/channels")

	importedChannel, err := formatChannelDetails(slug, channelURL)
	if err != nil {
		log.Fatalf("Error obtaining channel info: %v", err)
	}

	channel := channelList.Find(slug)
	if channel != nil {
		channel = &util.Channel{}
	}
	channel.Name = importedChannel.Name
	channel.Slug = importedChannel.Slug
	channel.Providers = importedChannel.Providers

	log.Printf("Title: %s, Count: %d\n", channel.Name, channel.Providers["youtube"].Subscribers)

	channelList[slug] = *channel

	util.SaveChannels(channelList, "../data/channels")
}

const launchWebServer = true

func handleError(err error, message string) {
	if message == "" {
		message = "Error making API call"
	}
	if err != nil {
		log.Fatalf(message+": %v", err.Error())
	}
}

const missingClientSecretsMessage = `
Please configure OAuth 2.0
To make this sample run, you need to populate the client_secrets.json file
found at:
   %v
with information from the {{ Google Cloud Console }}
{{ https://cloud.google.com/console }}
For more information about the client_secrets.json file format, please visit:
https://developers.google.com/api-client-library/python/guide/aaa_client_secrets
`

// getClient uses a Context and Config to retrieve a Token
// then generate a Client. It returns the generated Client.
func getClient(scope string) *http.Client {
	ctx := context.Background()

	b := []byte(accessJSON)

	// If modifying the scope, delete your previously saved credentials
	// at ~/.credentials/youtube-go.json
	config, err := google.ConfigFromJSON(b, scope)
	if err != nil {
		log.Fatalf("Unable to parse client secret file to config: %v", err)
	}

	// Use a redirect URI like this for a web app. The redirect URI must be a
	// valid one for your OAuth2 credentials.
	config.RedirectURL = "http://localhost:8090"
	// Use the following redirect URI if launchWebServer=false in oauth2.go
	// config.RedirectURL = "urn:ietf:wg:oauth:2.0:oob"

	cacheFile, err := tokenCacheFile()
	if err != nil {
		log.Fatalf("Unable to get path to cached credential file. %v", err)
	}
	tok, err := tokenFromFile(cacheFile)
	if err != nil {
		authURL := config.AuthCodeURL("state-token", oauth2.AccessTypeOffline)
		if launchWebServer {
			fmt.Println("Trying to get token from web")
			tok, err = getTokenFromWeb(config, authURL)
		} else {
			fmt.Println("Trying to get token from prompt")
			tok, err = getTokenFromPrompt(config, authURL)
		}
		if err == nil {
			saveToken(cacheFile, tok)
		}
	}
	return config.Client(ctx, tok)
}

// startWebServer starts a web server that listens on http://localhost:8080.
// The webserver waits for an oauth code in the three-legged auth flow.
func startWebServer() (codeCh chan string, err error) {
	listener, err := net.Listen("tcp", "localhost:8090")
	if err != nil {
		return nil, err
	}
	codeCh = make(chan string)

	go http.Serve(listener, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		code := r.FormValue("code")
		codeCh <- code // send code to OAuth flow
		listener.Close()
		w.Header().Set("Content-Type", "text/plain")
		fmt.Fprintf(w, "Received code: %v\r\nYou can now safely close this browser window.", code)
	}))

	return codeCh, nil
}

// openURL opens a browser window to the specified location.
// This code originally appeared at:
//   http://stackoverflow.com/questions/10377243/how-can-i-launch-a-process-that-is-not-a-file-in-go
func openURL(url string) error {
	var err error
	switch runtime.GOOS {
	case "linux":
		err = exec.Command("xdg-open", url).Start()
	case "windows":
		err = exec.Command("rundll32", "url.dll,FileProtocolHandler", url).Start()
	case "darwin":
		err = exec.Command("open", url).Start()
	default:
		err = fmt.Errorf("Cannot open URL %s on this platform", url)
	}
	return err
}

// Exchange the authorization code for an access token
func exchangeToken(config *oauth2.Config, code string) (*oauth2.Token, error) {
	tok, err := config.Exchange(oauth2.NoContext, code)
	if err != nil {
		log.Fatalf("Unable to retrieve token %v", err)
	}
	return tok, nil
}

// getTokenFromPrompt uses Config to request a Token and prompts the user
// to enter the token on the command line. It returns the retrieved Token.
func getTokenFromPrompt(config *oauth2.Config, authURL string) (*oauth2.Token, error) {
	var code string
	fmt.Printf("Go to the following link in your browser. After completing "+
		"the authorization flow, enter the authorization code on the command "+
		"line: \n%v\n", authURL)

	if _, err := fmt.Scan(&code); err != nil {
		log.Fatalf("Unable to read authorization code %v", err)
	}
	fmt.Println(authURL)
	return exchangeToken(config, code)
}

// getTokenFromWeb uses Config to request a Token.
// It returns the retrieved Token.
func getTokenFromWeb(config *oauth2.Config, authURL string) (*oauth2.Token, error) {
	codeCh, err := startWebServer()
	if err != nil {
		fmt.Printf("Unable to start a web server.")
		return nil, err
	}

	err = openURL(authURL)
	if err != nil {
		log.Fatalf("Unable to open authorization URL in web server: %v", err)
	} else {
		fmt.Println("Your browser has been opened to an authorization URL.",
			" This program will resume once authorization has been provided.")
		fmt.Println(authURL)
	}

	// Wait for the web server to get the code.
	code := <-codeCh
	return exchangeToken(config, code)
}

// tokenCacheFile generates credential file path/filename.
// It returns the generated credential path/filename.
func tokenCacheFile() (string, error) {
	usr, err := user.Current()
	if err != nil {
		return "", err
	}
	tokenCacheDir := filepath.Join(usr.HomeDir, ".credentials")
	os.MkdirAll(tokenCacheDir, 0700)
	return filepath.Join(tokenCacheDir,
		url.QueryEscape("youtube-go.json")), err
}

// tokenFromFile retrieves a Token from a given file path.
// It returns the retrieved Token and any read error encountered.
func tokenFromFile(file string) (*oauth2.Token, error) {
	f, err := os.Open(file)
	if err != nil {
		return nil, err
	}
	t := &oauth2.Token{}
	err = json.NewDecoder(f).Decode(t)
	defer f.Close()
	return t, err
}

// saveToken uses a file path to create a file and store the
// token in it.
func saveToken(file string, token *oauth2.Token) {
	fmt.Println("trying to save token")
	fmt.Printf("Saving credential file to: %s\n", file)
	f, err := os.OpenFile(file, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0600)
	if err != nil {
		log.Fatalf("Unable to cache oauth token: %v", err)
	}
	defer f.Close()
	json.NewEncoder(f).Encode(token)
}
