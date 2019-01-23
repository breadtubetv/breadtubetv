package cmd

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"
)

// configCmd represents the config command
var configCmd = &cobra.Command{
	Use:   "config [provider]",
	Short: "Set up various providers for Bake",
	Long: fmt.Sprintf(`Allows you to configure providers for Bake.
	
	Available providers: %s`, strings.Join(ProviderNames(), ", ")),
	Args: cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		var provider = args[0]

		if _, ok := Providers[provider]; !ok {
			panic(fmt.Sprintf("No provider existed called %s", provider))
		}

		Providers[provider]["config"].(func())()
	},
}

func init() {
	rootCmd.AddCommand(configCmd)
}
