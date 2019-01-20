# [BreadTube.tv](https://breadtube.tv)

This project aims to list anti-establishment public YouTubers for simplified onboarding of new members to the cause.

Growing from that base we want to build a platform which elevates content creators far beyond what YouTube can currently offer, and gives them resiliance from being censored or deplatformed.

For now though this is a *_really simple_* website

- Channels can be added to the homepage under `data/channels.yml`
- Videos can be added to the homepage under `data/channels.yml`
- Playlists can be created to link to videos and channels
- Social media can be changed in`config.toml`.

## Dependencies

## [Hugo (https://gohugo.io/)](https://gohugo.io/)

## Development

```
hugo serve
open localhost:1313
```

## [Contributing](https://github.com/breadtubetv/breadtubetv/blob/master/CONTRIBUTING.md)

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
