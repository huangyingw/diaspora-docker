FROM ruby:2.3-slim
MAINTAINER Denis Hovart <hello@denishovart.com>

RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends \
        build-essential cmake nodejs libpq-dev libmysqlclient-dev \
        pkg-config git imagemagick ghostscript

RUN mkdir -p /diaspora
WORKDIR /diaspora

ADD Gemfile* ./
RUN bundle install \
  --jobs $(nproc --all) --retry 3 \
    --with mysql postgresql

ADD . .

CMD script/server start -p 3000
