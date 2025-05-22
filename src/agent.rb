require "ruby_llm"
# Import the Modalities class to fix the "uninitialized constant" error
require "ruby_llm/model_info"
require_relative "tools/read_file"
require_relative "tools/list_files"
require_relative "tools/edit_file"
require_relative "tools/run_shell_command"

class Agent
  def initialize
    puts "Initializing agent with nova-lite-v1.0 model..."
    @chat = RubyLLM.chat(
      provider: :openai,
      model: "nova-lite-v1.0",  # Try a different model from the list
      assume_model_exists: true
    )
    # puts "Adding tools to agent..."
    @chat.with_tools(Tools::ReadFile, Tools::ListFiles, Tools::EditFile, Tools::RunShellCommand)
    # puts "Agent initialization complete."
  end

  def run
    puts "Chat with the agent. Type 'exit' to ... well, exit"
    loop do
      print "> "
      user_input = gets.chomp
      break if user_input == "exit"

      response = @chat.ask user_input
      puts response.content
    end
  end
end
