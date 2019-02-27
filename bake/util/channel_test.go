package util

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
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
	assert.NoError(t, err)
	assert.Equal(t, "Angie Speaks", channel.Name)
	assert.Equal(t, "angiespeaks", channel.Slug)
	assert.Len(t, channel.Providers, 0)

	require.Len(t, channel.remnant, 3)
	url := channel.remnant["url"]
	assert.Equal(t, url, "https://www.youtube.com/channel/UCUtloyZ_Iu4BJekIqPLc_fQ")

	description := channel.remnant["description"]
	assert.Equal(t, "Anarchist Leftist channel with a creative and mystical flair!", description)

	subscribers := channel.remnant["subscribers"]
	assert.Equal(t, 8367, subscribers)
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
	assert.NoError(t, err)
	assert.Equal(t, "anarchopac", channel.Slug)
	require.Len(t, channel.Providers, 2)

	youtubeProvider := channel.Providers["youtube"]
	assert.Equal(t, "anarchopac", youtubeProvider.Name)
	assert.Equal(t, MustParseURL("https://www.youtube.com/user/anarchopac"), youtubeProvider.URL)
	assert.Equal(t, uint64(15438), youtubeProvider.Subscribers)

	patreonProvider := channel.Providers["patreon"]
	assert.Equal(t, MustParseURL("https://www.patreon.com/anarchopac"), patreonProvider.URL)

	assert.Len(t, channel.remnant, 2)
}
