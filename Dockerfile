FROM ruby:2.7.6

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs imagemagick chromium-driver
ENV APP_PATH /myapp

RUN mkdir $APP_PATH
WORKDIR $APP_PATH
COPY Gemfile $APP_PATH/Gemfile
COPY Gemfile.lock $APP_PATH/Gemfile.lock
RUN bundle install

COPY . $APP_PATH

RUN yarn install

EXPOSE 3000

USER root

VOLUME /myapp/public
VOLUME /myapp/tmp
RUN mkdir -p /myapp/tmp/sockets
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD /bin/bash -c "rm -f tmp/pids/server.pid && bundle exec puma -C config/puma.rb"