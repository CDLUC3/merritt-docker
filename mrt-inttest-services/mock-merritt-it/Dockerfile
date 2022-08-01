# Mock ezid and storage service for ingest integration testing
#
# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mock-merritt-it:dev .
# aws ecr create-repository --repository-name mock-merritt-it
# docker push ${ECR_REGISTRY}/mock-merritt-it:dev

FROM ruby:2.6.6
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5
# Adding project files

COPY *.rb .
COPY data /data
COPY *.md /data
COPY static /data/static

EXPOSE 4567
CMD ["ruby", "app.rb"]
