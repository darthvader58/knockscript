Token = Struct.new(:type, :value, :line) do
    def to_s
      "<Token #{type}: #{value.inspect} (line #{line})>"
    end
  end
  
  # Token types:
  # :knock - "Knock knock"
  # :who_there - "Who's there?"
  # :identifier - Command name or variable name
  # :who_question - "[Command] who?"
  # :string - String literal
  # :number - Numeric literal
  # :boolean - true/false
  # :keyword - Language keywords (to, from, with, and, or, etc.)
  # :operator - +, -, *, /, etc.
  # :newline - Line break
  # :eof - End of file