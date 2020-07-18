# -- Versioning --

# These can be overridden using the build:args directive in docker-compose.yml
ARG RUBY_VERSION="2.7.1"
ARG NODE_VERSION="14.4.0"
ARG YARN_VERSION="1.17.3"

# Unfortunately, Heroku only supply a single image as the base for their dynos.
# Any other pre-reqs are installed later.
FROM heroku/heroku:18

ARG RUBY_VERSION
ARG NODE_VERSION
ARG YARN_VERSION

# -- Chrome --

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get -yqq update && \
    apt-get -yqq install curl unzip && \
    apt-get -yqq install xvfb tinywm && \
    apt-get -yqq install fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic && \
    apt-get -yqq install python software-properties-common autoconf bison build-essential libssl-dev libpq-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev libssl-dev libcurl4 libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/*

# -- Ruby --

RUN git clone https://github.com/rbenv/ruby-build.git \
  && PREFIX=/usr/local ./ruby-build/install.sh \
  && RUBY_CONFIGURE_OPTS=--disable-install-doc /usr/local/bin/ruby-build $RUBY_VERSION /usr/local/ruby

ENV PATH="/usr/local/ruby/bin:${PATH}"

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

# -- NodeJS --

RUN wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz && \
  mkdir -p /usr/local/lib/nodejs && \
  tar -xzvf node-v${NODE_VERSION}-linux-x64.tar.gz -C /usr/local/lib/nodejs

ENV PATH="/usr/local/lib/nodejs/node-v${NODE_VERSION}-linux-x64/bin:${PATH}"

# -- Build Deps --

RUN npm install -g yarn@${YARN_VERSION} gulp && \
    gem install bundler foreman

# -- Copy --

WORKDIR /app

# We copy the depfiles and run those first, so that we only have to 
# invalidate the layer cache if these files change, not just any file
COPY Gemfile Gemfile.lock package.json yarn.lock ./

# -- Install Pre-Reqs --

RUN bundle config --global silence_root_warning 1 \
  && bundle config --local with 'development test' \
  && bundle install \
  && yarn install --force 

# -- Copy Everything --

# This is the last step, because we don't want file changes to invalidate early layer caches
COPY . .

ENTRYPOINT ["./docker-entrypoint.sh"]
