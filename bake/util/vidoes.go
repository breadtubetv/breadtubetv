package util

import (
	"fmt"
	"io/ioutil"
	"path"
	"path/filepath"
	"strings"
)

// GetCreatorVideos returns a list of video IDs for a given creator
func GetCreatorVideos(slug string, projectRoot string) ([]string, error) {
	// Using "channels" for consistency, but will change to creators in refactor.
	videoDir, err := ioutil.ReadDir(path.Join(projectRoot, fmt.Sprintf("/data/videos/%s", slug)))
	if err != nil {
		return nil, err
	}

	var videoIds []string

	for _, file := range videoDir {
		if !file.IsDir() {
			fileName := file.Name()
			videoIds = append(videoIds, strings.TrimSuffix(fileName, filepath.Ext(fileName)))
		}
	}

	return videoIds, nil
}
