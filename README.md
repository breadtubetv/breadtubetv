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

### [Walkthrough Video](https://youtu.be/A13Xer-IvFs)

We have a video to walk you through the process, [let us know](https://breadtube.tv/discord) if you need any help!

### Bake Command Line Interface (Recommended)

```bake channel import SLUG youtube URL```

_Visit [github.com/breadtubetv/bake](https://github.com/breadtubetv/bake) for more information_

### Manually Add Channel

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
  ```
- Download the image and save it to [`static/img/channels/`](https://github.com/breadtubetv/breadtubetv/blob/master/static/img/channels)

### Creating a Playlist

- [Create a New File](https://github.com/breadtubetv/breadtubetv/new/master/content/playlists) under [content/playlists/](https://github.com/breadtubetv/breadtubetv/tree/master/content/playlists) (ProTip: [Copy an existing one](https://github.com/breadtubetv/breadtubetv/blob/master/content/playlists/welcome.md))
- Add the video ids you want into the new [Playlist Front Matter](https://gohugo.io/content-management/front-matter/)
- Add the videos you need to [`data/videos.yml`](https://github.com/breadtubetv/breadtubetv/blob/master/data/videos.yml)
- Add the channels you need to [`data/channels.yml`](https://github.com/breadtubetv/breadtubetv/blob/master/data/channels.yml)

## Staging

Pull requests are automatically deployed to a self contained environment for review.

## Production

### Hosting

While this is a simple Hugo website, hosting is on [netlify.com](https://netlify.com).
