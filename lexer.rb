require_relative 'token'

class Lexer
  KEYWORDS = %w[
    to from with and or not for
    plus minus times divided by
    greater than less equal
    true false list new of on
    Otherwise Done
  ].freeze
  
  def initialize(source)
    @source = source
    @position = 0
    @line = 1
    @tokens = []
  end
  
  def tokenize
    while @position < @source.length
      skip_whitespace_except_newline
      
      break if @position >= @source.length
      
      # Skip comments
      if peek == '#'
        skip_comment
        next
      end
      
      # Handle newlines
      if peek == "\n"
        @tokens << Token.new(:newline, "\n", @line) unless last_token_is_newline?
        advance
        @line += 1
        next
      end
      
      # Check for knock-knock patterns
      if match_pattern(/\AKnock knock/i)
        @tokens << Token.new(:knock, "Knock knock", @line)
        next
      end
      
      if match_pattern(/\AWho's there\?/i)
        @tokens << Token.new(:who_there, "Who's there?", @line)
        next
      end
      
      if peek == '"'
        tokenize_string
        next
      end
      
      if peek =~ /\d/
        tokenize_number
        next
      end
      
      if peek =~ /[a-zA-Z_]/
        tokenize_identifier
        next
      end
      
      case peek
      when ','
        @tokens << Token.new(:comma, ',', @line)
        advance
      when '('
        @tokens << Token.new(:lparen, '(', @line)
        advance
      when ')'
        @tokens << Token.new(:rparen, ')', @line)
        advance
      else
        raise "Unexpected character: #{peek.inspect} at line #{@line}"
      end
    end
    
    @tokens << Token.new(:eof, nil, @line)
    @tokens
  end
  
  private
  
  def peek(offset = 0)
    pos = @position + offset
    return nil if pos >= @source.length
    @source[pos]
  end
  
  def advance
    @position += 1
  end
  
  def skip_whitespace_except_newline
    while peek && peek =~ /[ \t\r]/
      advance
    end
  end
  
  def skip_comment
    while peek && peek != "\n"
      advance
    end
  end
  
  def last_token_is_newline?
    @tokens.last && @tokens.last.type == :newline
  end
  
  def match_pattern(regex)
    remaining = @source[@position..-1]
    match = remaining.match(regex)
    if match
      @position += match[0].length
      return match[0]
    end
    nil
  end
  
  def tokenize_string
    advance 
    start = @position
    
    while peek && peek != '"'
      if peek == '\\'
        advance 
        advance 
      else
        advance
      end
    end
    
    raise "Unterminated string at line #{@line}" unless peek == '"'
    
    value = @source[start...@position]
    advance 
    
    @tokens << Token.new(:string, value, @line)
  end
  
  def tokenize_number
    start = @position
    
    while peek && peek =~ /\d/
      advance
    end
    
    # for decimals
    if peek == '.' && peek(1) =~ /\d/
      advance 
      while peek && peek =~ /\d/
        advance
      end
    end
    
    value = @source[start...@position]
    @tokens << Token.new(:number, value.include?('.') ? value.to_f : value.to_i, @line)
  end
  
  def tokenize_identifier
    start = @position
    
    while peek && peek =~ /[a-zA-Z0-9_]/
      advance
    end
    
    value = @source[start...@position]
    
    # keyword check
    if KEYWORDS.include?(value)
      @tokens << Token.new(:keyword, value, @line)
    elsif value == 'true' || value == 'false'
      @tokens << Token.new(:boolean, value == 'true', @line)
    else
      skip_whitespace_except_newline
      if match_pattern(/\Awho\?/i)
        @tokens << Token.new(:who_question, "#{value} who?", @line)
      else
        @tokens << Token.new(:identifier, value, @line)
      end
    end
  end
end