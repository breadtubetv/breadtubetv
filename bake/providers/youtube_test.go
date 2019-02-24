package providers

import (
	"testing"

	"github.com/breadtubetv/bake/util"
	"github.com/magiconair/properties/assert"
)

func TestFormatChannelDetails(t *testing.T) {
	channel, err := formatChannelDetails(util.MustParseURL("https://www.youtube.com/channel/UC2-i3KuYoODXsM99Z3-Gm0A"))
	assert.Equal(t, nil, err)
	assert.Equal(t, channel.Name, "friendlyjordies")
}
