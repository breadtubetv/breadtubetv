// Copyright © 2019 NAME HERE <EMAIL ADDRESS>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cmd

import (
	"fmt"
	"log"
	"strings"

	"github.com/spf13/cobra"
)

// importCmd represents the import command
var importCmd = &cobra.Command{
	Use:   "import [provider] [channel_url]",
	Short: "Import a Channel into BreadtubeTV",
	Long: fmt.Sprintf(`Add the supplied channel into BreadtubeTV, without having to edit JSON.
	
	Available providers: %s`, strings.Join(ProviderNames(), ", ")),
	Args: cobra.ExactArgs(2),
	Run: func(cmd *cobra.Command, args []string) {
		var provider = args[0]
		var channelUrl = args[1]

		if _, ok := Providers[provider]; !ok {
			panic(fmt.Sprintf("No provider existed called %s", provider))
		}

		log.Printf("Importing %s...\n", channelUrl)
		Providers[provider]["channel_import"].(func(string))(channelUrl)
	},
}

func init() {
	channelCmd.AddCommand(importCmd)
}

func importChannel(channelUrl string) {
	fmt.Printf("called %s\n", channelUrl)
}
