#!/usr/bin/env ruby

# Load the gems and environment variables from .env file.
Dir.chdir(__dir__) do
  require "bundler/setup"
  require "dotenv/load"
end

require "ruby_llm"
require_relative "src/agent"

# Enable debug logging
RubyLLM.logger.level = Logger::DEBUG

# Print available models
# begin
#   puts "Checking available models..."
#   uri = URI.parse("http://localhost:4000/v1/models")
#   request = Net::HTTP::Get.new(uri)
#   request["Authorization"] = "Bearer #{ENV.fetch('LOCAL_API_KEY')}"
#   response = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(request) }
#   puts "Models response: #{response.body}"
# rescue => e
#   puts "Error checking models: #{e.message}"
# end

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("LOCAL_API_KEY", nil)
  config.openai_api_base = "http://localhost:4000"
  # Add any other configuration options here
end

# Let's inspect the RubyLLM configuration
# puts "RubyLLM configuration:"
# puts "API Key: #{ENV.fetch('LOCAL_API_KEY', nil)[0..5]}..." if ENV.fetch('LOCAL_API_KEY', nil)
# puts "API Base: http://localhost:4000"

Agent.new.run
