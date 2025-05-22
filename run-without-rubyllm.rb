#!/usr/bin/env ruby

# Load the gems and environment variables from .env file.
Dir.chdir(__dir__) do
  require "bundler/setup"
  require "dotenv/load"
end

require 'net/http'
require 'uri'
require 'json'

# Debug: Print the API key (first few characters only for security)
api_key = ENV.fetch('LOCAL_API_KEY', nil)
puts "Using API key: #{api_key ? api_key[0..5] + '...' : 'nil'}"

# Simple direct API chat implementation
class SimpleChat
  API_ENDPOINT = "http://localhost:4000/v1/chat/completions"
  MODEL = "claude-3-7-sonnet"
  
  def initialize(api_key)
    @api_key = api_key
    @messages = []
  end
  
  def ask(user_input)
    @messages << { "role" => "user", "content" => user_input }
    
    uri = URI.parse(API_ENDPOINT)
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{@api_key}"
    
    request.body = JSON.dump({
      "model" => MODEL,
      "messages" => @messages
    })
    
    begin
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end
      
      if response.code == "200"
        response_data = JSON.parse(response.body)
        assistant_message = response_data["choices"][0]["message"]["content"]
        @messages << { "role" => "assistant", "content" => assistant_message }
        return assistant_message
      else
        error_message = "API Error (#{response.code}): #{response.body}"
        puts error_message
        return "Error: #{error_message}"
      end
    rescue => e
      puts "Request Error: #{e.class}: #{e.message}"
      return "Error: #{e.message}"
    end
  end
end

# Run a simple chat loop
def run_simple_chat(api_key)
  chat = SimpleChat.new(api_key)
  
  puts "Chat with the simple agent. Type 'exit' to ... well, exit"
  loop do
    print "> "
    user_input = gets.chomp
    break if user_input == "exit"
    
    response = chat.ask(user_input)
    puts response
  end
end

# Test the API connection directly
def test_api_connection(api_key)
  uri = URI.parse("http://localhost:4000/v1/chat/completions")
  request = Net::HTTP::Post.new(uri)
  request["Content-Type"] = "application/json"
  request["Authorization"] = "Bearer #{api_key}"
  
  request.body = JSON.dump({
    "model" => "claude-3-7-sonnet",
    "messages" => [
      {
        "role" => "user",
        "content" => "Hello, this is a test message."
      }
    ]
  })
  
  begin
    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end
    
    puts "API Test Response Code: #{response.code}"
    puts "API Test Response Body: #{response.body[0..100]}..." if response.body
    
    if response.code == "200"
      puts "API connection successful!"
      return true
    else
      puts "API connection failed with status #{response.code}"
      return false
    end
  rescue => e
    puts "API connection error: #{e.class}: #{e.message}"
    return false
  end
end

# Main execution
puts "Testing direct API connection..."
if test_api_connection(api_key)
  puts "Starting simple chat agent..."
  run_simple_chat(api_key)
else
  puts "Skipping chat agent due to API connection failure"
end
# all_models = RubyLLM.models.all
# puts "Available models:"
# all_models.each do |model|
#   puts "- #{model.id}"  # or model['id'] depending on the structure
# end
