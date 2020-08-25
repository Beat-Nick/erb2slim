FROM ruby:2.7.1-slim

#grab libraires to build nokogiri
RUN apt-get update -qq && apt-get install -y build-essential \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/*

#create directory for app
ENV APP_ROOT /erb2slim/
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

#install dependencies first
ADD Gemfile* $APP_ROOT/
RUN bundle install

#copy app
ADD . $APP_ROOT

#start
EXPOSE 80
CMD ["bundle", "exec", "rackup", "config.ru", "-p", "80", "-s", "thin", "-o", "0.0.0.0"]