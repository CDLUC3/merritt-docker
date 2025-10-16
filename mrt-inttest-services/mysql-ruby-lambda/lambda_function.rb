# frozen_string_literal: true

# Docs say that the LambdaLayer gems are found mounted as /opt/ruby/gems but an inspection
# of the $LOAD_PATH shows that only /opt/ruby/lib is available. So we add what we want here
# and indicate exactly which folders contain the *.rb files
my_gem_path = Dir['/var/task/vendor/bundle/ruby/**/bundler/gems/**/lib/']
$LOAD_PATH.unshift(*my_gem_path)

require 'json'
require 'uc3-ssm'
require 'mysql2'

module LambdaFunctions
  # Placeholder entrypoint for a lambda base image built with mysql.
  # The build for this image is complicated because mysql requires a binary compile.
  class Handler
    def self.process(event:)
      json = {
        message: 'This is a placeholder for your lambda code',
        event: event
      }
      {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json; charset=utf-8'
        },
        statusCode: 200,
        body: json.to_json
      }
    rescue StandardError => e
      {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json; charset=utf-8'
        },
        statusCode: 500,
        body: { error: e.message }.to_json
      }
    end
  end
end
