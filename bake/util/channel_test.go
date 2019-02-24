package util

import (
	"testing"

	"github.com/magiconair/properties/assert"
	yaml "gopkg.in/yaml.v2"
)

func TestChannelUnmarshalYAML_OldFormat(t *testing.T) {
	channel := Channel{}

	data := `name: "Angie Speaks"
slug: "angiespeaks"
url: "https://www.youtube.com/channel/UCUtloyZ_Iu4BJekIqPLc_fQ"
description: "Anarchist Leftist channel with a creative and mystical flair!"
subscribers: 8367
tags: ["breadtube"]`

	err := yaml.Unmarshal([]byte(data), &channel)
	assert.Equal(t, err, nil)
	assert.Equal(t, channel.Slug, "angiespeaks")
	assert.Equal(t, len(channel.Providers), 0)

	assert.Equal(t, len(channel.remnant), 3)
	url := channel.remnant["url"]
	assert.Equal(t, url, MustParseURL("https://www.youtube.com/channel/UCUtloyZ_Iu4BJekIqPLc_fQ"))

	description := channel.remnant["description"]
	assert.Equal(t, description, "Anarchist Leftist channel with a creative and mystical flair!")

	subscribers := channel.remnant["subscribers"]
	assert.Equal(t, subscribers, 8367)
}

func TestChannelUnmarshalYAML_NewFormat(t *testing.T) {
	channel := Channel{}

	data := `name: "anarchopac"
slug: "anarchopac"
description: "I'm a disabled pan-sexual trans woman who talks about anarchism, feminism and marxism."
subscribers:
providers:
  youtube:
    name: "anarchopac"
    url: "https://www.youtube.com/user/anarchopac"
    subscribers: 15438
    description: ""
  patreon:
    name: "anarchopac"
    url: "https://www.patreon.com/anarchopac"
    description: "left-wing youtube videos"
tags: ["breadtube"]`

	err := yaml.Unmarshal([]byte(data), &channel)
	assert.Equal(t, err, nil)
	assert.Equal(t, channel.Slug, "anarchopac")
	assert.Equal(t, len(channel.Providers), 2)

	youtubeProvider := channel.Providers["youtube"]
	assert.Equal(t, youtubeProvider.Name, "anarchopac")
	assert.Equal(t, youtubeProvider.URL, MustParseURL("https://www.youtube.com/user/anarchopac"))
	assert.Equal(t, youtubeProvider.Subscribers, uint64(15438))

	patreonProvider := channel.Providers["patreon"]
	assert.Equal(t, patreonProvider.URL, MustParseURL("https://www.patreon.com/anarchopac"))

	assert.Equal(t, len(channel.remnant), 2)
}
