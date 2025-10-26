require_relative 'ast_nodes'
require_relative 'token'

class Parser
  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end
  
  def parse
    program = ProgramNode.new
    
    while !eof?
      skip_newlines
      break if eof?
      
      statement = parse_statement
      program.statements << statement if statement
      
      skip_newlines
    end
    
    program
  end
  
  private
  
  def current_token
    @tokens[@position]
  end
  
  def peek_token(offset = 1)
    @tokens[@position + offset]
  end
  
  def advance
    @position += 1
  end
  
  def eof?
    current_token.type == :eof
  end
  
  def skip_newlines
    while current_token.type == :newline
      advance
    end
  end
  
  def expect(type)
    if current_token.type != type
      raise "Expected #{type}, got #{current_token.type} at line #{current_token.line}"
    end
    token = current_token
    advance
    token
  end
  
  def parse_statement
    skip_newlines
    
    # Every statement starts with "Knock knock"
    expect(:knock)
    skip_newlines
    expect(:who_there)
    skip_newlines
    
    # Get the command
    command_token = expect(:identifier)
    command = command_token.value.downcase
    
    skip_newlines
    expect(:who_question)
    skip_newlines
    
    # Parse based on command type
    case command
    when 'set'
      parse_set_statement
    when 'print'
      parse_print_statement
    when 'if'
      parse_if_statement
    when 'while'
      parse_while_statement
    when 'for'
      parse_for_statement
    when 'class'
      parse_class_definition
    when 'method'
      parse_method_definition
    when 'call'
      parse_method_call_statement
    when 'get'
      parse_get_attribute_statement
    when 'push'
      parse_push_statement
    when 'pop'
      parse_pop_statement
    else
      raise "Unknown command: #{command} at line #{command_token.line}"
    end
  end
  
  def parse_set_statement
    # Set x to 5
    # Set x to y plus 3
    # Set age of person1 to 30
    
    variable_name = expect(:identifier).value
    
    # Check if it's setting an attribute or not
    if current_token.type == :keyword && current_token.value == 'of'
      advance 
      object_name = expect(:identifier).value
      expect_keyword('to')
      value = parse_expression
      return SetAttribute.new(variable_name, object_name, value)
    end
    
    expect_keyword('to')
    value = parse_expression
    
    SetStatement.new(variable_name, value)
  end
  
  def parse_print_statement
    # Print "Hello"
    # Print x
    expression = parse_expression
    PrintStatement.new(expression)
  end
  
  def parse_if_statement
    # If x greater than 5
    condition = parse_condition
    skip_newlines
    
    # Parse if body
    if_body = []
    while !eof? && !check_keyword('Otherwise') && !check_keyword('Done')
      skip_newlines
      break if check_keyword('Otherwise') || check_keyword('Done')
      if_body << parse_statement
      skip_newlines
    end
    
    # Parse else body
    else_body = []
    if check_keyword('Otherwise')
      advance
      skip_newlines
      
      while !eof? && !check_keyword('Done')
        skip_newlines
        break if check_keyword('Done')
        else_body << parse_statement
        skip_newlines
      end
    end
    
    expect_keyword('Done')
    
    IfStatement.new(condition, if_body, else_body)
  end
  
  def parse_while_statement
    # While x less than 10
    condition = parse_condition
    skip_newlines
    
    body = []
    while !eof? && !check_keyword('Done')
      skip_newlines
      break if check_keyword('Done')
      body << parse_statement
      skip_newlines
    end
    
    expect_keyword('Done')
    
    WhileStatement.new(condition, body)
  end
  
  def parse_for_statement
    variable_name = expect(:identifier).value
    expect_keyword('from')
    start_value = parse_expression
    expect_keyword('to')
    end_value = parse_expression
    skip_newlines
    
    body = []
    while !eof? && !check_keyword('Done')
      skip_newlines
      break if check_keyword('Done')
      body << parse_statement
      skip_newlines
    end
    
    expect_keyword('Done')
    
    ForStatement.new(variable_name, start_value, end_value, body)
  end
  
  def parse_class_definition
    class_name = expect(:identifier).value
    expect_keyword('with')
    
    attributes = []
    attributes << expect(:identifier).value
    
    while current_token.type == :keyword && current_token.value == 'and'
      advance
      attributes << expect(:identifier).value
    end
    
    ClassDefinition.new(class_name, attributes)
  end
  
  def parse_method_definition
    # Method greet for Person
    method_name = expect(:identifier).value
    expect_keyword('for')
    class_name = expect(:identifier).value
    skip_newlines
    
    body = []
    while !eof? && !check_keyword('Done')
      skip_newlines
      break if check_keyword('Done')
      body << parse_statement
      skip_newlines
    end
    
    expect_keyword('Done')
    
    MethodDefinition.new(method_name, class_name, [], body)
  end
  
  def parse_method_call_statement
    # Call greet on person1
    method_name = expect(:identifier).value
    expect_keyword('on')
    object_name = expect(:identifier).value
    
    MethodCall.new(method_name, object_name)
  end
  
  def parse_get_attribute_statement
    # Get name from person1
    attribute_name = expect(:identifier).value
    expect_keyword('from')
    object_name = expect(:identifier).value
    
    GetAttribute.new(attribute_name, object_name)
  end
  
  def parse_push_statement
    # Push 4 to mylist
    value = parse_expression
    expect_keyword('to')
    array_name = expect(:identifier).value
    
    PushStatement.new(value, array_name)
  end
  
  def parse_pop_statement
    # Pop from mylist
    expect_keyword('from')
    array_name = expect(:identifier).value
    
    PopStatement.new(array_name)
  end
  
  def parse_condition
    # x greater than 5
    # x equal to 10
    left = parse_expression
    
    operator = nil
    if current_token.type == :keyword
      case current_token.value
      when 'greater'
        advance
        expect_keyword('than')
        operator = '>'
      when 'less'
        advance
        expect_keyword('than')
        operator = '<'
      when 'equal'
        advance
        expect_keyword('to')
        operator = '=='
      when 'not'
        advance
        expect_keyword('equal')
        expect_keyword('to')
        operator = '!='
      end
    end
    
    raise "Expected comparison operator at line #{current_token.line}" unless operator
    
    right = parse_expression
    
    BinaryOperation.new(left, operator, right)
  end
  
  def parse_expression
    left = parse_term
    
    while current_token.type == :keyword && ['plus', 'minus'].include?(current_token.value)
      operator = current_token.value == 'plus' ? '+' : '-'
      advance
      right = parse_term
      left = BinaryOperation.new(left, operator, right)
    end
    
    left
  end
  
  def parse_term
    left = parse_factor
    
    while current_token.type == :keyword && ['times', 'divided'].include?(current_token.value)
      if current_token.value == 'divided'
        advance
        expect_keyword('by')
        operator = '/'
      else
        operator = '*'
        advance
      end
      right = parse_factor
      left = BinaryOperation.new(left, operator, right)
    end
    
    left
  end
  
  def parse_factor
    token = current_token
    
    case token.type
    when :number
      advance
      Literal.new(token.value)
    when :string
      advance
      Literal.new(token.value)
    when :boolean
      advance
      Literal.new(token.value)
    when :identifier
      # Could be: variable, "new ClassName", "value of object", etc.
      if token.value.downcase == 'new'
        parse_new_instance
      elsif peek_token&.type == :keyword && peek_token.value == 'of'
        # value of counter
        attribute = token.value
        advance
        expect_keyword('of')
        object_name = expect(:identifier).value
        GetAttribute.new(attribute, object_name)
      elsif token.value.downcase == 'list'
        parse_array_literal
      else
        advance
        Variable.new(token.value)
      end
    when :keyword
      if token.value == 'not'
        advance
        operand = parse_factor
        UnaryOperation.new('not', operand)
      elsif token.value == 'list'
        parse_array_literal
      elsif token.value == 'new'
        parse_new_instance
      else
        raise "Unexpected keyword in expression: #{token.value} at line #{token.line}"
      end
    else
      raise "Unexpected token in expression: #{token.type} at line #{token.line}"
    end
  end
  
  def parse_new_instance
    expect_keyword('new')
    class_name = expect(:identifier).value
    expect_keyword('with')
    
    arguments = {}
    arguments[expect(:identifier).value] = parse_expression
    
    while current_token.type == :keyword && current_token.value == 'and'
      advance
      attr_name = expect(:identifier).value
      arguments[attr_name] = parse_expression
    end
    
    NewInstance.new(class_name, arguments)
  end
  
  def parse_array_literal
    expect_keyword('list')
    expect_keyword('with')
    
    elements = []
    elements << parse_expression
    
    while current_token.type == :comma
      advance
      elements << parse_expression
    end
    
    ArrayLiteral.new(elements)
  end
  
  def check_keyword(value)
    current_token.type == :keyword && current_token.value == value
  end
  
  def expect_keyword(value)
    unless current_token.type == :keyword && current_token.value == value
      raise "Expected keyword '#{value}', got #{current_token.value.inspect} at line #{current_token.line}"
    end
    advance
  end
end