FROM ruby:3.4

WORKDIR /agent
COPY . .
RUN bundle install

VOLUME /workspace
WORKDIR /workspace

CMD ["/agent/run.rb"]
