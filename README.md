# BreadTube.tv

This is the working project for the redesign and relaunch of BreadTube.tv.

This second iteration of the project aims to solve these two key problems of the first site.

- Design: Improve Usability through a purposeful design
- Moderation: Improve Usability through an automated update system

## Design

Daniel Torres has provided the wireframes and logos for the site
https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/

## Application

This application is written in [Ruby on Rails](https://rubyonrails.org/) and runs on Docker.

### Developing

To start required services in the current console and have everything reload when files are changed, use:

```
docker-compose up
```

After some time (various bundles and templates will need to be built/cached), you can access your instance of app at [http://localhost:3000](http://localhost:3000).

To start the services in detached mode (will stay alive if terminal closes), use `docker-compose up -d`. If you do this and want to access the logs of the containers, you can use `docker-compose logs -f`.

To bring the services down (**will wipe database**), use:

```
docker-compose down
```

### Database Setup

Once the services are up, you can use the following to initialise the database:

```
docker-compose exec web rails db:create db:setup
```

### Accessing Containers

Generally speaking, any command can be executed on the appropriate Docker container using `docker-compose exec <container> <command>`. Note that the container must be up to use `exec`.

The available containers are:
- web
- webpacker
- postgres

## Functionality

The following functionality is available, designs for further improvements are also provided.

- [x] Visitor can see a Homepage
  - [Desktop](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/)
  - [Mobile](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/bc514ad6-7d6a-47f6-bc20-d0b83272de69/homepage-mobile)
- [x] Visitor can see navigation
  - [Mobile](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/9d78188e-40af-483e-b238-e77ecc09a9fd/menu)
- [x] Visitor can see a footer
  - [Desktop](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/87696b05-0aa4-4025-9c9d-e45f3e2b0cd7/iPhone-X-XS-11-Pro-1)
- [x] Visitor can see a list of Channels
  - [Desktop](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/ebda9a89-9d4a-40c1-a128-2d019d143030/channel-list)
  - [Mobile](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/9b394a14-bd0a-46e6-810c-a9d0d9bca923/channel-page-mobile-5)
- [x] Visitor can see a Channel
  - [Desktop](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/3cefb3fb-2f32-4a1b-9107-2fb8a8587209/Channel-That-s-Streaming)
  - [Mobile](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/443e6396-88bc-4363-bdd5-e534174aec7c/channel-mobile-1)
- [x] Visitor can see a list of Videos
  - [Desktop](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/4d497f0c-058a-4881-9f9b-d5b815ab349c/Videos)
  - [Mobile](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/1beaf92c-caff-4051-a4fd-fc1d5dc81bc3/video-page-mobile-3)
- [x] Visitor can see a Video
  - [Desktop](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/b8d8f5b8-25e0-46f7-b4db-247c8bc4ca97/video)
  - [Mobile](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/f1a6b11f-138a-464a-85f8-9dba3105b3e2/single-video-mobile-2)
- [x] Visitor can see a list of Livestreams
  - [Desktop](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/0758c504-650f-44e4-a108-ede9bb51b8e8/Livestreams)
  - [Mobile](https://xd.adobe.com/view/f7e45c84-fe46-4754-48a9-28cf24dc3a5b-81d5/screen/bb283909-ea2d-4996-b75f-0f1b3e8614db/video-page-mobile-4)

## Administration

**TODO: Images are served locally, which means channel images need to be added to the repo in development**
**This means you need to import a channel in development and deploy the code, before importing in production**
**Resolving this requires storing images for production on a hosted service, or not using Heroku**

```
rails breadtube:heroku:pull
```

### Import a YouTube Channel

Create channel and set title, description, image

```
rails breadtube:import:youtube[<url>]
```

#### Locally

```
docker-compose run web rails breadtube:import:youtube[https://www.youtube.com/channel/UCRwzzq8hVdFjcNw_I9wZrVQ]
```

#### Heroku

```
heroku run rails breadtube:import:youtube[https://www.youtube.com/channel/UCR_RL13AHgqojmKC6HFfzRA]
```

### Refresh a Channel

Pull in all data from the channel (uses API)

```
heroku run rails breadtube:refresh:channel[
```

### Sync a Channel

Pull in last 10 videos

#### Locally

```
heroku run rails breadtube:sync:channel[zoomernation]
```

## Roadmap

### 2020 Q4

- [x] Fix build pipeline for tests are deploys
- [ ] Complete automated feature testing
- [ ] Simplify adding a channel to one command / page
- [ ] Optmize build/deploy pipeline

### 2021 Q1

- TBD
