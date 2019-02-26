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

### Adding a Channel

#### [Walkthrough Video](https://youtu.be/jpOun7YXFpg)

- Edit [`data/channels.yml`](https://github.com/breadtubetv/breadtubetv/blob/master/data/channels.yml)
- Put the channel information in (order by subscribers)
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

You'll need a copy of the project in the relevent folder.

```
mkdir -p ~/.go/src/github.com/
cd ~/.go/src/github.com/
git clone git@github.com:breadtubetv/breadtubetv.git
```

And you'll need to install dependencies

```
cd ~/.go/src/github.com/breadtubetv/bake
go get
```

#### Importing a Channel

```
go run main.go config youtube #follow prompts
go run main.go channel import contrapoints youtube https://www.youtube.com/user/contrapoints
```

#### Testing (WIP)

```
cd ~/.go/src/github.com/breadtubetv/bake
go get -t

co util/
go test

co providers/
go test
```

#### Building

```
cd ~/.go/src/github.com/breadtubetv/bake
go build -o bake main.go
```

#### Importing a Channel

```
./bake config youtube #follow prompts
./bake channel import contrapoints youtube https://www.youtube.com/user/contrapoints
```

## Staging

Pull requests are automatically deployed to a self contained environment for review.

## Production

### Hosting

While this is a simple Hugo website, hosting is on [netlify.com](https://netlify.com).
