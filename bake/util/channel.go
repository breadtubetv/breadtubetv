package util

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/url"
	"os"
	"path"

	yaml "gopkg.in/yaml.v2"
)

type Channel struct {
	Name      string              `yaml:"name"`
	Slug      string              `yaml:"slug"`
	Providers map[string]Provider `yaml:"providers"`
	Tags      []interface{}       `yaml:"tags"`
}

type Provider struct {
	Name        string   `yaml:"name"`
	Slug        string   `yaml:"slug"`
	URL         *url.URL `yaml:"url"`
	Description string   `yaml:"description,omitempty"`
	Subscribers uint64   `yaml:"subscribers"`
}

type ChannelList []Channel

func LoadChannels(dataDir string) ChannelList {
	channelList := ChannelList{}

	files, err := ioutil.ReadDir(dataDir)
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		// load each yaml
		filePath := path.Join(dataDir, file.Name())

		data, err := ioutil.ReadFile(filePath)
		if err != nil {
			log.Fatal(err)
		}

		channel := Channel{}

		err = yaml.Unmarshal([]byte(data), &channel)
		if err != nil {
			log.Fatalf("error: %v", err)
		}

		channelList = append(channelList, channel)
	}

	return channelList
}

// Contains returns true if the supplied URL matches any provider's URL
func (channelList *ChannelList) Contains(channelUrl *url.URL) bool {
	for _, channel := range *channelList {
		for _, provider := range channel.Providers {
			if provider.URL == channelUrl {
				return true
			}
		}
	}

	return false
}

func SaveChannels(channelList ChannelList, dataDir string) bool {
	// delete everything in the directory first, since we're re-saving it
	files, err := ioutil.ReadDir(dataDir)
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		os.Remove(path.Join(dataDir, file.Name()))
	}

	// then re-marshal and save
	for _, channel := range channelList {
		data, err := yaml.Marshal(channel)
		if err != nil {
			log.Fatalf("error: %v", err)
			return false
		}

		filePath := path.Join(dataDir, fmt.Sprintf("%s.yml", channel.Slug))
		log.Printf("Saving %s\n", filePath)

		err = ioutil.WriteFile(filePath, data, os.ModePerm)
		if err != nil {
			log.Fatalf("error: %v", err)
			return false
		}
	}

	return true
}
