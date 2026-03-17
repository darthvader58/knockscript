require_relative 'ast_nodes'
require_relative 'token'

class Parser
  COMMAND_ALIASES = {
    'print' => 'print',
    'lettuce' => 'print',
    'set' => 'set',
    'alby-setin' => 'set',
    'if' => 'if',
    'anita' => 'if',
    'while' => 'while',
    'antil' => 'while',
    'for' => 'for',
    'wanna' => 'for',
    'class' => 'class',
    'kit' => 'class',
    'method' => 'method',
    'dewey' => 'method',
    'call' => 'call',
    'europe' => 'call',
    'get' => 'get',
    'justin' => 'get',
    'push' => 'push',
    'sherwood' => 'push',
    'pop' => 'pop',
    'iva' => 'pop',
    'patcha' => 'set_index',
    'slotta' => 'set_dictionary_key',
    'skipper' => 'remove_value',
    'function' => 'function',
    'doozy' => 'function',
    'return' => 'return',
    'backatcha' => 'return',
    'break' => 'break',
    'enough' => 'break',
    'continue' => 'continue',
    'carryon' => 'continue',
    'try' => 'try',
    'chance' => 'try'
  }.freeze

  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def parse
    program = ProgramNode.new

    until eof?
      skip_newlines
      break if eof?

      program.statements << parse_statement
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
    advance while current_token.type == :newline
  end

  def expect(type)
    raise "Expected #{type}, got #{current_token.type} at line #{current_token.line}" if current_token.type != type

    token = current_token
    advance
    token
  end

  def expect_word
    token = current_token
    raise "Expected identifier or keyword at line #{token.line}" unless [:identifier, :keyword].include?(token.type)

    advance
    token.value
  end

  def current_value
    current_token.value.to_s
  end

  def current_value_downcase
    current_value.downcase
  end

  def token_matches?(token, value)
    return false unless token
    return false unless [:identifier, :keyword].include?(token.type)

    token.value.to_s.downcase == value.downcase
  end

  def check_phrase(*words)
    words.each_with_index.all? { |word, index| token_matches?(peek_token(index), word) }
  end

  def match_phrase(*words)
    return false unless check_phrase(*words)

    words.length.times { advance }
    true
  end

  def expect_phrase(*words)
    raise "Expected '#{words.join(' ')}' at line #{current_token.line}" unless match_phrase(*words)
  end

  def check_any_phrase?(phrases)
    phrases.any? { |phrase| check_phrase(*phrase) }
  end

  def expect_keyword(value)
    raise "Expected keyword '#{value}', got #{current_token.value.inspect} at line #{current_token.line}" unless token_matches?(current_token, value)

    advance
  end

  def parse_statement
    skip_newlines
    expect(:knock)
    skip_newlines
    expect(:who_there)
    skip_newlines

    command_token = expect(:identifier)
    command = COMMAND_ALIASES[command_token.value.downcase]
    raise "Unknown command: #{command_token.value} at line #{command_token.line}" unless command

    skip_newlines
    expect(:who_question)
    skip_newlines

    case command
    when 'set' then parse_set_statement
    when 'print' then parse_print_statement
    when 'if' then parse_if_statement
    when 'while' then parse_while_statement
    when 'for' then parse_for_statement
    when 'class' then parse_class_definition
    when 'method' then parse_method_definition
    when 'call' then parse_call_statement
    when 'get' then parse_get_attribute_statement
    when 'push' then parse_push_statement
    when 'pop' then parse_pop_statement
    when 'set_index' then parse_set_index_statement
    when 'set_dictionary_key' then parse_set_dictionary_key_statement
    when 'remove_value' then parse_remove_value_statement
    when 'function' then parse_function_definition
    when 'return' then parse_return_statement
    when 'break' then BreakStatement.new
    when 'continue' then ContinueStatement.new
    when 'try' then parse_try_catch_statement
    end
  end

  def parse_block_until(phrases)
    body = []

    until eof?
      skip_newlines
      break if eof? || check_any_phrase?(phrases)

      body << parse_statement
      skip_newlines
    end

    body
  end

  def parse_identifier_list
    identifiers = [expect(:identifier).value]

    while token_matches?(current_token, 'and')
      advance
      identifiers << expect(:identifier).value
    end

    identifiers
  end

  def parse_expression_list(separator = 'and')
    expressions = [parse_expression]

    while token_matches?(current_token, separator)
      advance
      expressions << parse_expression
    end

    expressions
  end

  def parse_key_operand
    case current_token.type
    when :identifier
      Literal.new(expect(:identifier).value)
    when :string, :number, :boolean
      parse_factor
    else
      parse_expression
    end
  end

  def parse_set_statement
    variable_name = expect(:identifier).value

    if token_matches?(current_token, 'of')
      advance
      object_name = expect(:identifier).value
      expect_keyword('to')
      return SetAttribute.new(variable_name, object_name, parse_expression)
    end

    expect_keyword('to')
    SetStatement.new(variable_name, parse_expression)
  end

  def parse_print_statement
    PrintStatement.new(parse_expression)
  end

  def parse_if_statement
    condition = parse_condition
    if_body = parse_block_until([['anita', 'also'], ['Otherwise'], ['Done']])

    elsif_branches = []
    while check_phrase('anita', 'also')
      expect_phrase('anita', 'also')
      elsif_condition = parse_condition
      elsif_body = parse_block_until([['anita', 'also'], ['Otherwise'], ['Done']])
      elsif_branches << [elsif_condition, elsif_body]
    end

    else_body = []
    if token_matches?(current_token, 'Otherwise')
      advance
      else_body = parse_block_until([['Done']])
    end

    expect_keyword('Done')
    IfStatement.new(condition, if_body, elsif_branches, else_body)
  end

  def parse_while_statement
    condition = parse_condition
    body = parse_block_until([['Done']])
    expect_keyword('Done')
    WhileStatement.new(condition, body)
  end

  def parse_for_statement
    variable_name = expect(:identifier).value
    expect_keyword('from')
    start_value = parse_expression
    expect_keyword('to')
    end_value = parse_expression
    body = parse_block_until([['Done']])
    expect_keyword('Done')
    ForStatement.new(variable_name, start_value, end_value, body)
  end

  def parse_class_definition
    class_name = expect(:identifier).value
    expect_keyword('with')
    ClassDefinition.new(class_name, parse_identifier_list)
  end

  def parse_method_definition
    method_name = expect(:identifier).value
    expect_keyword('for')
    class_name = expect(:identifier).value
    parameters = []
    if token_matches?(current_token, 'with')
      advance
      parameters = parse_identifier_list
    end

    body = parse_block_until([['Done']])
    expect_keyword('Done')
    MethodDefinition.new(method_name, class_name, parameters, body)
  end

  def parse_function_definition
    function_name = expect(:identifier).value
    parameters = []
    if token_matches?(current_token, 'with')
      advance
      parameters = parse_identifier_list
    end

    body = parse_block_until([['Done']])
    expect_keyword('Done')
    FunctionDefinition.new(function_name, parameters, body)
  end

  def parse_call_statement
    parse_call_expression
  end

  def parse_call_expression
    name = expect(:identifier).value
    object_name = nil
    arguments = []

    if token_matches?(current_token, 'on')
      advance
      object_name = expect(:identifier).value
    end

    if token_matches?(current_token, 'with')
      advance
      arguments = parse_expression_list
    end

    if object_name.nil? && token_matches?(current_token, 'on')
      advance
      object_name = expect(:identifier).value
    end

    CallExpression.new(name, object_name, arguments)
  end

  def parse_get_attribute_statement
    attribute_name = expect(:identifier).value
    expect_keyword('from')
    object_name = expect(:identifier).value
    GetAttribute.new(attribute_name, object_name)
  end

  def parse_push_statement
    value = parse_expression
    expect_keyword('to')
    PushStatement.new(value, expect(:identifier).value)
  end

  def parse_pop_statement
    expect_keyword('from')
    PopStatement.new(expect(:identifier).value)
  end

  def parse_set_index_statement
    index = parse_expression
    expect_keyword('of')
    array_name = expect(:identifier).value
    expect_keyword('to')
    SetIndexStatement.new(index, array_name, parse_expression)
  end

  def parse_set_dictionary_key_statement
    key = parse_key_operand
    expect_keyword('of')
    dictionary_name = expect(:identifier).value
    expect_keyword('to')
    DictionarySetStatement.new(key, dictionary_name, parse_expression)
  end

  def parse_remove_value_statement
    value = parse_expression
    expect_keyword('from')
    RemoveValueStatement.new(value, expect(:identifier).value)
  end

  def parse_try_catch_statement
    try_body = parse_block_until([['Unlucky'], ['Done']])
    catch_body = []

    if token_matches?(current_token, 'Unlucky')
      advance
      catch_body = parse_block_until([['Done']])
    end

    expect_keyword('Done')
    TryCatchStatement.new(try_body, catch_body)
  end

  def parse_return_statement
    expression = current_token.type == :newline ? Literal.new(nil) : parse_expression
    ReturnStatement.new(expression)
  end

  def parse_condition
    left = parse_expression

    operator =
      if match_phrase('greater', 'than')
        '>'
      elsif match_phrase('less', 'than')
        '<'
      elsif match_phrase('equal', 'to')
        '=='
      elsif match_phrase('not', 'equal', 'to') || match_phrase('nope', 'equal', 'to')
        '!='
      else
        raise "Expected comparison operator at line #{current_token.line}"
      end

    BinaryOperation.new(left, operator, parse_expression)
  end

  def parse_expression
    left = parse_term

    loop do
      operator =
        if token_matches?(current_token, 'plus')
          advance
          '+'
        elsif check_phrase('with', 'extra')
          expect_phrase('with', 'extra')
          '+'
        elsif token_matches?(current_token, 'minus')
          advance
          '-'
        elsif token_matches?(current_token, 'without')
          advance
          '-'
        end

      break unless operator

      left = BinaryOperation.new(left, operator, parse_term)
    end

    left
  end

  def parse_term
    left = parse_factor

    loop do
      operator =
        if token_matches?(current_token, 'times')
          advance
          '*'
        elsif check_phrase('on', 'repeat')
          expect_phrase('on', 'repeat')
          '*'
        elsif match_phrase('divided', 'by') || match_phrase('split', 'by')
          '/'
        end

      break unless operator

      left = BinaryOperation.new(left, operator, parse_factor)
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
    when :lparen
      advance
      expression = parse_expression
      expect(:rparen)
      expression
    when :identifier
      parse_identifier_factor
    when :keyword
      parse_keyword_factor
    else
      raise "Unexpected token in expression: #{token.type} at line #{token.line}"
    end
  end

  def parse_identifier_factor
    case current_value_downcase
    when 'call'
      advance
      parse_call_expression
    when 'europe'
      advance
      parse_call_expression
    when 'howie'
      advance
      LengthExpression.new(parse_factor)
    when 'whichy'
      advance
      index = parse_expression
      expect_keyword('from')
      IndexExpression.new(index, parse_factor)
    when 'keysy'
      advance
      key = parse_expression
      expect_keyword('from')
      DictionaryGetExpression.new(key, parse_factor)
    when 'dosset'
      advance
      second_word = expect(:identifier).value
      raise "Expected 'Dosset Dave' at line #{current_token.line}" unless second_word.downcase == 'dave'
      value = parse_expression
      expect_keyword('in')
      IncludesExpression.new(value, parse_factor)
    when 'askem'
      advance
      InputExpression.new(current_token.type == :newline ? Literal.new('') : parse_expression)
    when 'oxford'
      advance
      parse_dictionary_literal
    when 'fresh'
      parse_new_instance
    else
      parse_variable_like
    end
  end

  def parse_keyword_factor
    case current_value_downcase
    when 'not', 'nope'
      advance
      UnaryOperation.new('not', parse_factor)
    when 'list'
      parse_array_literal
    when 'new'
      parse_new_instance
    else
      raise "Unexpected keyword in expression: #{current_token.value} at line #{current_token.line}"
    end
  end

  def parse_variable_like
    token = expect(:identifier)

    if token_matches?(current_token, 'of')
      advance
      GetAttribute.new(token.value, expect(:identifier).value)
    else
      Variable.new(token.value)
    end
  end

  def parse_new_instance
    if token_matches?(current_token, 'new')
      advance
    else
      expect(:identifier)
    end

    class_name = expect(:identifier).value
    expect_keyword('with')

    arguments = { expect(:identifier).value => parse_expression }
    while token_matches?(current_token, 'and')
      advance
      arguments[expect(:identifier).value] = parse_expression
    end

    NewInstance.new(class_name, arguments)
  end

  def parse_array_literal
    expect_keyword('list')
    expect_keyword('with')

    elements = [parse_expression]
    while current_token.type == :comma
      advance
      elements << parse_expression
    end

    ArrayLiteral.new(elements)
  end

  def parse_dictionary_literal
    expect_keyword('with')

    entries = {}
    key = expect(:identifier).value
    entries[key] = parse_expression

    while token_matches?(current_token, 'and')
      advance
      key = expect(:identifier).value
      entries[key] = parse_expression
    end

    DictionaryLiteral.new(entries)
  end
end
