FROM ruby:2.7.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -qq -y build-essential nodejs yarn \
    libpq-dev 
RUN mkdir /animatedgifme
WORKDIR /animatedgifme
COPY Gemfile /animatedgifme/Gemfile
COPY Gemfile.lock /animatedgifme/Gemfile.lock
RUN gem install bundler
RUN bundle check || bundle install
COPY . /animatedgifme
RUN yarn install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]