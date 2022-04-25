# Mock ezid and storage service for ingest integration testing
#
# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-ezid-store-mock:dev .
# aws ecr create-repository --repository-name mrt-ezid-store-mock
# docker push ${ECR_REGISTRY}/mrt-ezid-store-mock:dev

FROM ruby:2.6.6
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5
# Adding project files

COPY *.rb .

EXPOSE 4567
CMD ["ruby", "app.rb"]
