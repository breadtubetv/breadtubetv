# -- Versioning --

FROM timbru31/ruby-node:2.7

# -- Ruby --

ENV PATH="/usr/local/ruby/bin:${PATH}"

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

# -- Build Deps --

RUN npm install -g yarn gulp && \
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
