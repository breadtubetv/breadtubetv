package cmd

import (
	"fmt"
	"log"

	"github.com/breadtubetv/breadtubetv/bake/providers"
	"github.com/breadtubetv/breadtubetv/bake/util"
	"github.com/spf13/cobra"
)

var updateCmd = &cobra.Command{
	Use:   "update",
	Short: "Refresh all channel files",
	Long:  fmt.Sprintf(`Refresh all channels with the most current information from their respective providers.`),
	Run: func(cmd *cobra.Command, args []string) {
		log.Println("Updating channels...")
		updateChannels()
	},
}

func init() {
	channelCmd.AddCommand(updateCmd)
}

func updateChannels() {
	channels := util.LoadChannels("../data/channels")

	for _, channel := range channels {
		youtube, err := providers.FetchDetails(channel.YouTubeURL())

		channel.Providers["youtube"] = youtube

		err = util.SaveChannel(channel, "../data/channels")
		if err != nil {
			log.Printf("Failed to update channel %s (%s), error: %v", channel.Name, channel.Slug, err)
		}
	}

	util.SaveChannels(channels, "../data/channels")
}
