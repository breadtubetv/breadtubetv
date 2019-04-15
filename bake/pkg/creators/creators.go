package creators

import (
	"fmt"

	"github.com/breadtubetv/breadtubetv/bake/pkg/providers"
	"github.com/spf13/viper"
)

// Creator refers to a single BreadTube creator.
// A creator can have many providers.
type Creator struct {
	name       string
	permalink  string
	slug       string
	tags       []string
	Providers  []providers.Provider
	bakeConfig *viper.Viper
}

// AddConfig allows the caller to provide a configuration
func (c *Creator) AddConfig(config *viper.Viper) {
	c.bakeConfig = config
	fmt.Println(config.AllSettings())
}
