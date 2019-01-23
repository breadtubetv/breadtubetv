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
	Run: func(cmd *cobra.Command, args []string) {
	},
}

func init() {
	rootCmd.AddCommand(configCmd)
}
