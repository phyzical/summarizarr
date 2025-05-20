ARG RUBY_VERSION="please_change_me"
# Version is pinned via .ruby-version
FROM ruby:${RUBY_VERSION} AS base

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

FROM base AS dependencies

RUN bundle install

FROM dependencies AS test

RUN bundle install --with test

COPY . .

FROM dependencies AS production

COPY . .

ENTRYPOINT [ "ruby", "main.rb" ]