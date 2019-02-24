package providers

import (
	"testing"

	"github.com/breadtubetv/bake/util"
	"github.com/stretchr/testify/assert"
)

func TestFormatChannelDetails(t *testing.T) {
	channel, err := formatChannelDetails("Friendly-Jordies", util.MustParseURL("https://www.youtube.com/channel/UC2-i3KuYoODXsM99Z3-Gm0A"))
	assert.NoError(t, err)
	assert.Equal(t, "friendlyjordies", channel.Name)
	assert.Equal(t, "Friendly-Jordies", channel.Slug)
}
