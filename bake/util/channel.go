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
	Providers map[string]Provider
	Tags      []interface{}
	remnant   map[string]interface{}
}

// YouTubeURL fetches the URL if this channel has the encoded provider URL and
// falls back to the top level channel URL if it's not found.
func (c Channel) YouTubeURL() *URL {
	if youtube, ok := c.Providers["youtube"]; ok {
		return youtube.URL
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
				return fmt.Errorf("error parsing slug: '%s', %T is not a string", value, value)
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
func (channelList *ChannelList) Contains(slug string) bool {
	_, ok := map[string]Channel(*channelList)[slug]
	return ok
}

// Find returns a channel that matches the specified slug
func (channelList *ChannelList) Find(slug string) *Channel {
	channel := map[string]Channel(*channelList)[slug]
	return &channel
}

// SaveChannels saves all the channel definitions back to disk
func SaveChannels(channelList ChannelList, dataDir string) bool {
	for _, channel := range channelList {
		err := SaveChannel(channel, dataDir)
		if err != nil {
			log.Fatalf("error: %v", err)
			return false
		}
	}

	return true
}

// SaveChannel saves an individual channel, overwriting the channel file if it
// already exists
func SaveChannel(channel Channel, dataDir string) error {
	filePath := path.Join(dataDir, fmt.Sprintf("%s.yml", channel.Slug))
	log.Printf("Saving %s\n", filePath)

	data, err := yaml.Marshal(channel)
	if err != nil {
		return err
	}

	return ioutil.WriteFile(filePath, data, os.ModePerm)
}
