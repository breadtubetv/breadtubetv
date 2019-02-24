package providers

import (
	"net/url"
	"testing"

	"github.com/magiconair/properties/assert"
)

func TestFormatChannelDetails(t *testing.T) {
	mustParse := func(urls string) *url.URL {
		u, err := url.Parse(urls)
		if err != nil {
			t.Fatalf("Parse(%q) got err %v", urls, err)
		}
		return u
	}

	channel, err := formatChannelDetails(mustParse("https://www.youtube.com/channel/UC2-i3KuYoODXsM99Z3-Gm0A"))
	assert.Equal(t, nil, err)
	assert.Equal(t, channel.Name, "friendlyjordies")
}
