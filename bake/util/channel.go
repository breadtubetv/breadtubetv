package util

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path"
	"strings"

	yaml "gopkg.in/yaml.v2"
)

// Channel represents a YouTube channel and it's associated providers
type Channel struct {
	Name      string
	Slug      string
	Permalink string
	Providers map[string]Provider
	Tags      []interface{}
	remnant   map[string]interface{}
}

// YouTubeURL fetches the URL if this channel has the encoded provider URL and
// falls back to the top level channel URL if it's not found.
func (c Channel) YouTubeURL() *URL {
	if youtube, ok := c.Providers["youtube"]; ok {
		if youtube.URL != nil {
			return youtube.URL
		}
	}
	if urlStr, ok := c.remnant["url"]; ok {
		if url, ok := urlStr.(string); ok {
			return MustParseURL(url)
		}
	}
	return nil
}

// MarshalYAML handles the well defined channel details as well as any other fields specified
func (c Channel) MarshalYAML() (interface{}, error) {
	values := map[string]interface{}{}

	values["name"] = c.Name
	values["slug"] = c.Slug
	values["permalink"] = c.Permalink
	if len(c.Providers) > 0 {
		values["providers"] = c.Providers
	}
	if len(c.Tags) > 0 {
		values["tags"] = c.Tags
	}

	for key, value := range c.remnant {
		if value != nil {
			values[key] = value
		}
	}

	return values, nil
}

// UnmarshalYAML handles the well defined channel details as well as any other fields specified
func (c *Channel) UnmarshalYAML(unmarshal func(interface{}) error) error {
	values := map[string]interface{}{}
	if err := unmarshal(&values); err != nil {
		return err
	}

	channel := Channel{Providers: make(map[string]Provider), remnant: make(map[string]interface{})}
	for key, value := range values {
		if value == nil {
			continue
		}

		switch strings.ToLower(key) {
		case "name":
			name, ok := value.(string)
			if !ok {
				return fmt.Errorf("error parsing name: '%s', %T is not a string", value, value)
			}
			channel.Name = name
			break
		case "slug":
			slug, ok := value.(string)
			if !ok {
				return fmt.Errorf("error parsing slug: '%s', %T is not a string", value, value)
			}
			channel.Slug = slug
			break
		case "permalink":
			permalink, ok := value.(string)
			if !ok {
				return fmt.Errorf("error parsing permalink: '%s', %T is not a string", value, value)
			}
			channel.Permalink = permalink
			break
		case "tags":
			// Handle non array tags
			if tags, ok := value.(string); ok {
				channel.Tags = []interface{}{tags}
				continue
			}

			tags, ok := value.([]interface{})
			if !ok {
				return fmt.Errorf("error parsing tags: '%s', %T is not a string", value, value)
			}
			channel.Tags = tags
			break
		case "providers":
			providers, ok := value.(map[interface{}]interface{})
			if !ok {
				return fmt.Errorf("error parsing providers: '%s', %T is not a dictionary", value, value)
			}
			if err := unmarshalProviders(providers, channel.Providers); err != nil {
				return err
			}
			break
		default:
			channel.remnant[key] = value
			break
		}
	}

	c.Name = channel.Name
	c.Slug = channel.Slug
	c.Permalink = channel.Permalink
	c.Providers = channel.Providers
	c.Tags = channel.Tags
	c.remnant = channel.remnant
	return nil
}

// Provider is one of youtube or patreon
type Provider struct {
	Name        string
	Slug        string
	URL         *URL
	Description string
	Subscribers uint64
}

// yaml package does not have very composeable Unmarshalling, so we have to
// write an unmarshaller for Provider as well :(
func unmarshalProviders(values map[interface{}]interface{}, providers map[string]Provider) error {
	for key, value := range values {
		name, ok := key.(string)
		if !ok {
			return fmt.Errorf("error parsing provider list: '%+v', %T is not a string", name, name)
		}

		input, ok := value.(map[interface{}]interface{})
		if !ok {
			return fmt.Errorf("error parsing providers: '%+v', %T is not a dictionary", value, value)
		}

		provider := Provider{}
		err := unmarshalProvider(input, &provider)
		if err != nil {
			return err
		}

		providers[name] = provider
	}

	return nil
}

func unmarshalProvider(values map[interface{}]interface{}, out *Provider) error {
	provider := Provider{}
	for key, value := range values {
		name, ok := key.(string)
		if !ok {
			return fmt.Errorf("error parsing provider field: '%+v', %T is not a string", name, name)
		}

		if value == nil {
			continue
		}

		switch strings.ToLower(name) {
		case "name":
			name, ok := value.(string)
			if !ok {
				return fmt.Errorf("error parsing name: '%s', %T is not a string", value, value)
			}
			provider.Name = name
			break
		case "slug":
			slug, ok := value.(string)
			if !ok {
				return fmt.Errorf("error parsing slug: '%s', %T is not a string", value, value)
			}
			provider.Slug = slug
			break
		case "url":
			s, ok := value.(string)
			if !ok {
				return fmt.Errorf("error parsing url: '%s', %T is not a string", value, value)
			}
			url, err := ParseURL(s)
			if err != nil {
				return err
			}
			provider.URL = url
			break
		case "description":
			description, ok := value.(string)
			if !ok {
				return fmt.Errorf("error parsing description: '%s', %T is not a string", value, value)
			}
			provider.Description = description
			break
		case "subscribers":
			if value == nil {
				continue
			}

			subscribers, ok := value.(int)
			if !ok {
				return fmt.Errorf("error parsing subscribers: '%s', %T is not an int", value, value)
			}
			provider.Subscribers = uint64(subscribers)
			break
		}
	}

	*out = provider
	return nil
}

// ChannelList is a collection of channels
type ChannelList map[string]Channel

// LoadChannels reads all the channel definitions off disk
func LoadChannels(dataDir string) ChannelList {
	channelList := make(ChannelList)

	files, err := ioutil.ReadDir(dataDir)
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		// load each yaml
		filePath := path.Join(dataDir, file.Name())

		data, err := ioutil.ReadFile(filePath)
		if err != nil {
			log.Fatalf("Error reading channel file '%s': %v", filePath, err)
		}

		channel := Channel{}

		err = yaml.Unmarshal([]byte(data), &channel)
		if err != nil {
			log.Panicf("Error unmarshalling into channel: %v", err)
		}

		channelList[channel.Slug] = channel
	}

	return channelList
}

// Contains returns true if the supplied URL matches any provider's URL
func (channelList ChannelList) Contains(slug string) bool {
	_, ok := map[string]Channel(channelList)[slug]
	return ok
}

// Find returns a channel that matches the specified slug
func (channelList ChannelList) Find(slug string) (*Channel, bool) {
	channel, ok := map[string]Channel(channelList)[slug]
	return &channel, ok
}

// SaveChannels saves all the channel definitions back to disk
func SaveChannels(channelList ChannelList, dataDir string) bool {
	for _, channel := range channelList {
		err := SaveChannel(&channel, dataDir)
		if err != nil {
			log.Fatalf("error: %v", err)
			return false
		}
	}

	return true
}

// SaveChannel saves an individual channel, overwriting the channel file if it
// already exists
func SaveChannel(channel *Channel, dataDir string) error {
	filePath := path.Join(dataDir, fmt.Sprintf("%s.yml", channel.Slug))
	log.Printf("Saving %s\n", filePath)

	data, err := yaml.Marshal(channel)
	if err != nil {
		return err
	}

	return ioutil.WriteFile(filePath, data, os.ModePerm)
}

// ChannelPage represents all the fields required
// to create a channel specific page.
type ChannelPage struct {
	Title      string
	TypeString string `yaml:"type"` // type is reserved
	Channel    string
	Menu       struct {
		Main struct {
			Parent string
		}
	}
	Videos []string `yaml:",omitempty"`
}

// CreateChannelPage takes the permalink for the channel
// and creates a .md file in the content directory.
func CreateChannelPage(channel *Channel, projectRoot string) error {
	fileName := fmt.Sprintf("%s.md", channel.Slug)
	dataDir := path.Join(projectRoot, "/content/")
	if _, err := ioutil.ReadFile(fmt.Sprintf("%s%s", dataDir, fileName)); err == nil {
		return fmt.Errorf(fmt.Sprintf("Channel Page %s.md already exists.", channel.Slug))
	}

	channelPage := &ChannelPage{
		Title:      channel.Name,
		TypeString: "channels",
		Channel:    channel.Slug,
		Menu: struct {
			Main struct {
				Parent string
			}
		}{
			Main: struct {
				Parent string
			}{
				Parent: "Channels",
			},
		},
	}

	videos, _ := GetCreatorVideos(channel.Slug, projectRoot)
	if videos != nil {
		channelPage.Videos = videos
	}

	pageBytes, err := yaml.Marshal(&channelPage)
	if err != nil {
		return fmt.Errorf("Failed to marshal yaml for %s channel page. \nError: %s", channel.Slug, err.Error())
	}

	pageBytes = []byte(strings.Join([]string{"---\n", string(pageBytes), "---"}, ""))
	log.Printf("Saving %s/%s", dataDir, fileName)
	err = ioutil.WriteFile(path.Join(projectRoot, fmt.Sprintf("/content/%s.md", channel.Slug)), pageBytes, os.ModePerm)
	if err != nil {
		return fmt.Errorf("Failed to marshal yaml for %s channel page", channel.Slug)
	}

	return nil
}
