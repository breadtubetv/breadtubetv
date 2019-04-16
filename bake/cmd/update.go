package cmd

import (
	"fmt"
	"log"
	"os"

	"github.com/breadtubetv/breadtubetv/bake/providers"
	"github.com/breadtubetv/breadtubetv/bake/util"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var updateCmd = &cobra.Command{
	Use:   "update [channel slugs...]",
	Short: "Refresh all channel files",
	Long:  fmt.Sprintf(`Refresh all channels with the most current information from their respective providers.`),
	Args:  cobra.ArbitraryArgs,
	Run: func(cmd *cobra.Command, args []string) {
		if len(args) == 0 {
			log.Println("Updating channels...")
			updateChannels()
		} else {
			log.Printf("Updating channels %s...\n", args)
			updateChannelList(args)
		}
	},
}

func init() {
	channelCmd.AddCommand(updateCmd)
}

func updateChannelList(args []string) {
	dataDir := fmt.Sprintf("%s/data/channels", os.ExpandEnv(viper.GetString("projectRoot")))
	channels := util.LoadChannels(dataDir)

	for _, channelSlug := range args {
		channel, ok := channels.Find(channelSlug)
		if !ok {
			log.Printf("Couldn't find channel with slug '%s', skipping...", channelSlug)
			continue
		}

		url := channel.YouTubeURL()
		if url == nil {
			log.Printf("Failed to update channel %s (%s), missing URL", channel.Name, channel.Slug)
			continue
		}

		youtube, err := providers.FetchDetails(url)

		channel.Providers["youtube"] = youtube

		err = util.SaveChannel(channel, dataDir)
		if err != nil {
			log.Printf("Failed to update channel %s (%s), error: %v", channel.Name, channel.Slug, err)
		}
	}
}

func updateChannels() {
	channels := util.LoadChannels(fmt.Sprintf("%s/data/channels", os.ExpandEnv(viper.GetString("projectRoot"))))

	for _, channel := range channels {
		url := channel.YouTubeURL()
		if url == nil {
			log.Printf("Failed to update channel %s (%s), missing URL", channel.Name, channel.Slug)
			continue
		}

		youtube, err := providers.FetchDetails(url)

		channel.Providers["youtube"] = youtube

		err = util.SaveChannel(&channel, "../data/channels")
		if err != nil {
			log.Printf("Failed to update channel %s (%s), error: %v", channel.Name, channel.Slug, err)
		}
	}
}
