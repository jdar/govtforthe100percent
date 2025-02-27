FROM ruby:3.2.2-slim AS ruby-base

# Install required system packages
RUN apt-get update && apt-get install -y \
  curl \
  g++ \
  gcc \
  libfontconfig \
  libpq-dev \
  make \
  patch \
  xz-utils \
  chromium \
  && rm -rf /var/lib/apt/lists/*

# Stage 2: Node Base (Debian-based Node image for compatibility)
FROM node:20-slim AS node-base

# Remove any pre-existing Yarn binaries and install Yarn globally
RUN rm -f /usr/local/bin/yarn /usr/local/bin/yarnpkg && npm install -g yarn

# Stage 3: Final Application Image (combining Ruby and Node)
FROM ruby-base

# Copy the entire /usr/local directory from node-base
COPY --from=node-base /usr/local/ /usr/local/

# Verify installations (prints versions during build)
RUN node -v && npm -v && yarn -v
RUN yarn add webpack webpack-cli

# Create and set working directory
RUN mkdir /refugeexperiences
WORKDIR /refugeexperiences
COPY . .

RUN bundle install

# Copy and install Node.js packages with Yarn
COPY package.json yarn.lock /refugeexperiences/
RUN yarn install --pure-lockfile && yarn cache clean

# Copy the entrypoint script and ensure it is executable
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Set the entrypoint so that the server.pid is removed at startup
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Set default command for Heroku to start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]