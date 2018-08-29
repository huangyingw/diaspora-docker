FROM ruby:2.3
# Using the ruby onbuild image is not currently possible because some gems dependencies
# needs to be resoveld before `bundle install` starts (rugged uses cmake).

MAINTAINER Denis Hovart <hello@denishovart.com>

ENV DIASPORA_PATH "/diaspora"
RUN mkdir -p $DIASPORA_PATH
WORKDIR $DIASPORA_PATH

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
        cmake nodejs ghostscript

ADD Gemfile* $DIASPORA_PATH/

RUN bundle config --global jobs $(nproc --all) && \
        bundle config --global retry 5 && \
        bundle config --global with postgresql \
        && bundle install

COPY . $DIASPORA_PATH/

CMD script/server start
