#!/usr/bin/env ruby

# Load the gems and environment variables from .env file.
Dir.chdir(__dir__) do
  require "bundler/setup"
  require "dotenv/load"
end

require "ruby_llm"
require_relative "src/agent"

# RubyLLM.configure do |config|
#   config.anthropic_api_key = ENV.fetch("ANTHROPIC_API_KEY", nil)
#   config.default_model = "claude-3-7-sonnet"
# end

RubyLLM.configure do |config|
  config.anthropic_api_key = ENV.fetch('ANTHROPIC_API_KEY', nil) # Or set your key directly
  config.openai_api_base = "http://localhost:4000"      # Replace with your custom endpoint and port
  config.default_model = "claude-3-7-sonnet"
end

Agent.new.run
