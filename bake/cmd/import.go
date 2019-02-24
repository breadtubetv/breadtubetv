package cmd

import (
	"fmt"
	"log"
	"strings"

	"github.com/breadtubetv/bake/util"
	"github.com/spf13/cobra"
)

// importCmd represents the import command
var importCmd = &cobra.Command{
	Use:   "import [slug] [provider] [channel_url]",
	Short: "Import a Channel into BreadtubeTV",
	Long: fmt.Sprintf(`Add the supplied channel into BreadtubeTV, without having to edit JSON.
	
	Available providers: %s`, strings.Join(ProviderNames(), ", ")),
	Args: cobra.ExactArgs(3),
	Run: func(cmd *cobra.Command, args []string) {
		var slug = args[0]
		var provider = args[1]
		var channelURL, err = util.ParseURL(args[2])

		if err != nil {
			log.Fatalf("Improperly formatted URL provided '%s': %v", args[1], err)
		}

		if _, ok := Providers[provider]; !ok {
			log.Fatalf("No provider exists called %s", provider)
		}

		log.Printf("Importing %s...\n", channelURL)
		Providers[provider]["channel_import"].(func(string, *util.URL))(slug, channelURL)
	},
}

func init() {
	channelCmd.AddCommand(importCmd)
}

func importChannel(channelURL string) {
	fmt.Printf("called %s\n", channelURL)
}
