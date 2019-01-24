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

type Channel struct {
	Name        string        `yaml:"name"`
	Slug        string        `yaml:"slug"`
	URL         string        `yaml:"url"`
	Subscribers uint64        `yaml:"subscribers"`
	Tags        []interface{} `yaml:"tags"`
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

func (channelList *ChannelList) Contains(channelUrl string) bool {
	var urlList []string
	for _, channel := range *channelList {
		urlList = append(urlList, channel.URL)
	}

	found := false
	for _, url := range urlList {
		if url == strings.TrimRight(channelUrl, "/") {
			found = true
			break
		}
	}

	return found
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
