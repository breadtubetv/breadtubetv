package cmd

import (
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/breadtubetv/breadtubetv/bake/util"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// importCmd represents the import command
var importCmd = &cobra.Command{
	Use:   "import <slug> <provider> <channel_url>",
	Short: "Import a channel into BreadtubeTV",
	Long: fmt.Sprintf(`Add the supplied channel into BreadtubeTV, without having to edit JSON.

	Available providers: %s`, strings.Join(ProviderNames(), ", ")),
	Args: cobra.ExactArgs(3),
	Run: func(cmd *cobra.Command, args []string) {
		var slug = args[0]
		var provider = args[1]
		var channelURL, err = util.ParseURL(args[2])
		projectRoot := os.ExpandEnv(viper.GetString("projectRoot"))

		if err != nil {
			log.Fatalf("Improperly formatted URL provided '%s': %v", args[1], err)
		}

		if _, ok := Providers[provider]; !ok {
			log.Fatalf("No provider exists called %s", provider)
		}

		log.Printf("Importing %s...\n", channelURL)
		Providers[provider]["channel_import"].(func(string, *util.URL, string))(slug, channelURL, projectRoot)
	},
}

func init() {
	channelCmd.AddCommand(importCmd)
}
