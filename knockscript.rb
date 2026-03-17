require_relative 'lexer'
require_relative 'parser'
require_relative 'interpreter'

class KnockScript
  def self.run(source_code, input_provider = nil)
    # Tokenize
    lexer = Lexer.new(source_code)
    tokens = lexer.tokenize
    
    # Parse
    parser = Parser.new(tokens)
    ast = parser.parse
    
    # Interpret
    interpreter = Interpreter.new(input_provider)
    interpreter.execute(ast)
  end
  
  def self.run_file(filename, input_provider = nil)
    source_code = File.read(filename)
    run(source_code, input_provider)
  end
end

# directly from cli
if __FILE__ == $0
  if ARGV.length != 1
    puts "Usage: ruby knockscript.rb <filename>"
    exit 1
  end
  
  result = KnockScript.run_file(ARGV[0])
  
  if result[:success]
    puts result[:output]
  else
    puts "Error: #{result[:error]}"
    exit 1
  end
end
