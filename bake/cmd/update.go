package cmd

import (
	"fmt"
	"log"

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
	channelList := util.LoadChannels("../data/channels")
	util.SaveChannels(channelList, "../data/channels")
}
