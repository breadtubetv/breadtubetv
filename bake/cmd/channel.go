package cmd

import (
	"github.com/spf13/cobra"
)

// channelCmd represents the channel command
var channelCmd = &cobra.Command{
	Use:   "channel",
	Short: "Manage channels in the BreadtubeTV channel list",
	Long:  `This can be used to add a new channel to BreadtubeTV, without requiring you to touch JSON.`,
	Run: func(cmd *cobra.Command, args []string) {

	},
}

func init() {
	rootCmd.AddCommand(channelCmd)
}
