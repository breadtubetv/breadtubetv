# [BreadTube.tv](https://breadtube.tv)

This project aims to list anti-establishment public YouTubers for simplified onboarding of new members to the cause.

[Check out the announcement on r/breadtube to follow the discussion](https://www.reddit.com/r/BreadTube/comments/ahxwrm/breadtubetv_is_live_and_open_source_you_can_help/).

Growing from this base we want to build a platform which elevates content creators far beyond what YouTube can currently offer, and gives them resilience from being censored or deplatformed.

For now though this is a *_really simple_* website

- Channels can be added to the homepage under `data/channels.yml`
- Videos can be added to the homepage under `data/channels.yml`
- Playlists can be created to link to videos and channels
- Social media can be changed in`config.toml`.

We'd like to simplify the process for adding content, [this is a project you can help with](https://github.com/breadtubetv/breadtubetv/issues/22)!

## Dependencies

## [Hugo (https://gohugo.io/)](https://gohugo.io/)

## Content Development

```
hugo serve
open localhost:1313
```

## [Contributing](https://github.com/breadtubetv/breadtubetv/blob/master/CONTRIBUTING.md)

### Configuring the `bake` CLI

The `.bake.yaml` configuration file can be stored in the following locations:

- `$HOME/.bake.yaml`
- `./bake.yaml` (In other words, the current directory from which you're running the CLI)

Current configuration options and default values:

- `projectRoot: "../"` : Directory of channel data files.    
  E.g. `$GOPATH/src/github.com/breadtubetv/breadtubetv/data/channels`

### Adding a Channel

#### [Walkthrough Video](https://youtu.be/jpOun7YXFpg) (Out of date)

You can use the `bake` CLI, instructions [here](#Importing-a-Channel) to add channels OR

- Create a `<channelName>.yaml` file in [`data/channels/`](https://github.com/breadtubetv/breadtubetv/blob/master/data/channels)
- Fill in the required information:
  ```yaml
    name: Readable Name
    permalink: <slug>
    providers:
      twitter:
        name: Readable Name
        slug: username
        url: https://www.twitter.com/<username>
      youtube:
        name: Readable Name
        slug: youtube-id
        url: https://www.youtube.com/channel/<youtube-id>
        subscribers: 9000
    slug: <slug>
    tags:
    - breadtube
  ```
- Create a `<channelName>.md` file in [`content`](https://github.com/breadtubetv/breadtubetv/blob/master/content)
- Follow this example format:
  ```
  ---
  title: "<Readable Name>"
  type: "channels"
  channel: "<slug>"
  menu:
    main:
      parent: "Channels"
videos:
- abc123def
  ---
- Download the image and save it to [`static/img/channels/`](https://github.com/breadtubetv/breadtubetv/blob/master/static/img/channels)

### Creating a Playlist

- [Create a New File](https://github.com/breadtubetv/breadtubetv/new/master/content/playlists) under [content/playlists/](https://github.com/breadtubetv/breadtubetv/tree/master/content/playlists) (ProTip: [Copy an existing one](https://github.com/breadtubetv/breadtubetv/blob/master/content/playlists/welcome.md))
- Add the video ids you want into the new [Playlist Front Matter](https://gohugo.io/content-management/front-matter/)
- Add the videos you need to [`data/videos.yml`](https://github.com/breadtubetv/breadtubetv/blob/master/data/videos.yml)
- Add the channels you need to [`data/channels.yml`](https://github.com/breadtubetv/breadtubetv/blob/master/data/channels.yml)

## Script Development

Scripts are being written in Go, this keeps the scripting and operational language the same, provides cross system compatibility, and gives everyone an opportunity to learn a new programming language.

### Installation

#### Installing Go

This is going to be dependent on your system, we recommend following https://golang.org/doc/install

#### Developing

You'll need a copy of the project in your `$GOPATH`.

```
go get github.com/breadtubetv/breadtubetv
cd $GOPATH/github.com/breadtubetv/breadtubetv/bake
```

And you'll need to install bake's dependencies with:

```
go get
```

#### Installing

This will put the `bake` command in your path:

```
go install
```

#### Importing a Channel

You can run bake directly from the source like so:

```
go run main.go config youtube #follow prompts
go run main.go channel import contrapoints youtube https://www.youtube.com/user/contrapoints
```

Or if you've installed it:

```
bake config youtube #follow prompts
bake channel import contrapoints youtube https://www.youtube.com/user/contrapoints
```

#### Testing

Bake has some very basic tests for now, they can be run with the standard go test command line:

```
go get -t ./...
go test ./...
```

## Staging

Pull requests are automatically deployed to a self contained environment for review.

## Production

### Hosting

While this is a simple Hugo website, hosting is on [netlify.com](https://netlify.com).

## Forestry
