# Stage 1: Ruby Base (Debian-based, ARM64)
FROM --platform=linux/arm64 ruby:3.2.2-slim AS ruby-base

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
FROM --platform=linux/arm64 node:16-slim AS node-base

# Remove any pre-existing Yarn binaries and install Yarn globally
RUN rm -f /usr/local/bin/yarn /usr/local/bin/yarnpkg && npm install -g yarn

# Stage 3: Final Application Image (combining Ruby and Node)
FROM ruby-base

# Copy the entire /usr/local directory from node-base
COPY --from=node-base /usr/local/ /usr/local/

# Verify installations (prints versions during build)
RUN node -v && npm -v && yarn -v

# Create and set working directory
RUN mkdir /refugetravesties
WORKDIR /refugetravesties

# Copy and install Ruby dependencies
COPY Gemfile Gemfile.lock /refugetravesties/
RUN bundle install

# Copy and install Node.js packages with Yarn
COPY package.json yarn.lock /refugetravesties/
RUN yarn install --pure-lockfile && yarn cache clean