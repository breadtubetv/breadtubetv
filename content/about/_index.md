---
title: About
type: page
---

## Introduction

[BreadTube.tv](/) is the collaborative effort of Creators, Subscribers, Moderators, Developers, Designers, and Coordinators working together to list content that is posted on [r/BreadTube](/reddit) and related mediums.

BreadTube is a reference to the left-wing anarchist Peter Kropotkin's 1982 book, ["The Conquest of Bread"](https://theanarchistlibrary.org/library/petr-kropotkin-the-conquest-of-bread). The goal of the community is to challenge the far-right content creators who have taken power on services like YouTube for the purpose of spreading hate and to instead educate people on how their world operates, the alternative possible visions for our future, and how we organize ourselves to get there.

> ["The Making of a YouTube Radical" New York Times](https://www.nytimes.com/interactive/2019/06/08/technology/youtube-radical.html)

This website is a resource for discovering and sharing BreadTube content, content is suggested by public users through various forms ([Channels](/channels/new), [Playlists](/playlists/new)), these submissions are re viewable by interested members on [Discord](httsp://breadtube.tv/discord) and then added to the source code by a team of volunteer developers.

Services such as YouTube use hidden algorithms to serve content to users, the preferences of these algorithms are determined by YouTube's values, which as they are a subsidiary of Google is  the generation of capital through Advertising.

Replacing a service like YouTube is unfeasible for any community, let alone one as small as ours, however utilizing its features and circumnavigating the algorithm using our own listings is possible.

With [BreadTube.tv](/) we get the benefit of having a low cost (practically free) tool to do that, effectively using the master's tools to bring down their oppressive house of global capitalist domination.

## Development

Unlike traditional websites [BreadTube.tv](/) does not use a dynamic content management system such as WordPress or Drupal, instead it uses a more modern, secure, fast, and distributed collection of technologies referred to as [JAMStack](https://jamstack.org/).

This means there is no login to the website, no user accounts, and no personally identifiable information collected in order for this to operate or for submissions to be sent.

It also means that to make the changes go live we need to rely on developers and moderators to collaborate together in a non-hierarchical way in order to advance the features and content of the website.

While this inherently means there is a learning curve required in order to ultimately contribute to the website, that learning helps people involved better understand the fundamentals of website development and how information is transmitted across the Internet.

There are currently two core projects being actively developed and would really benefit from **your** help!

## Projects

### [BreadTubeTV &middot; GitHub](https://github.com/breadtubetv/breadtubetv)

[README.md](https://github.com/breadtubetv/breadtubetv/blob/master/README.md)

This is the website you are currently looking at, it is developed on top of [Hugo](https://gohugo.io), a static website generator developed on the incredibly fast programming language [GoLang](https://golang.org).

Content, Design, and Code changes are all submitted to the website the same way, using [GitHub Pull Requests](https://help.github.com/en/articles/about-pull-requests).

Reviewing these pull requests are a great first step for anyone interested in contributing to the project, when a developer tags a pull request as ["needs review"](https://github.com/breadtubetv/breadtubetv/pulls?q=is%3Apr+is%3Aopen+label%3A%22needs+review%22) this signifies that it needs someone else in the community to look at and approve the changes.

#### Additional Goals

- [Rapid responses to new content](https://github.com/breadtubetv/breadtubetv/pull/282)
- Fully automated submission to pull request creation
- Support for live and upcoming events
- Support for content other than videos
- [Support for PeerTube and other sources](https://github.com/breadtubetv/breadtubetv/issues/23)
  - [Video Pages and QueerTube Sources (in development)](https://github.com/breadtubetv/breadtubetv/pull/198)
- Mobile Apps that load this website

### [Bake &middot; GitHub](https://github.com/breadtubetv/bake)

[README.md](https://github.com/breadtubetv/bake/blob/master/README.md)

The content which is submitted to the website is at present a collection of creators and their videos, sometimes organized into Playlists.

Getting the relevant information about a channel or video is possible to be done manually, and when the [BreadTube.tv](/) project was initially started this is how it was done.

However our goal is to eventually automate this process, and in the mean time to at least reduce the burden on developers by giving them simple to use tools that allow them to pull the information from the Internet to aid content changes.

This is where Bake comes in, this command line tool gives developers everything they need to add channels and their related videos, as with Hugo this tool is built using [GoLang](https://golang.org).

#### Importing a Channel

If a channel does not exist yet we can create it, all we need to know is the slug of the channel and the YouTube URL so that we can import the relevant information.


```bash
bake channel import \
     contrapoints \
     youtube \
     https://www.youtube.com/channel/UCNvsIonJdJ5E4EXMa65VYpA
```

#### Updating a Channel

```bash
bake channel update contrapoints
```

#### Updating all Channels

```bash
bake channel update
```

#### Importing a Video


```bash
bake import video \
     --provider youtube \
     --creator contrapoints
     --url https://www.youtube.com/watch?v=n9mspMJTNEY
```

## Values

Our values as a development team are those of any other self organizing community and that of the conquest of bread itself. In this regard the means are distribution systems for content which educates people about the history, struggle, and potential futures of our species in regards to the philosophies, politics, and economics which define our lives.

As a development team our utility and existence to the movement is dependent on us being informed, understanding, and empathetic of the needs of the community and to respond by developing them the things that can make them flourish.

We do not consider ourselves to be the single instance of this mission, our collaboration is entirely voluntary and non binding, what we learn and achieve together on the projects we embark on will serve ourselves and further causes throughout time in unknowing ways.

## Feedback

The easiest way to talk to everyone involved is at [BreadTube.tv/Discord](/discord)

You can also [open a new issue](/github/issues/new) on GitHub to suggest a change.
