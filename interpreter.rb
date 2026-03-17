require_relative 'environment'
require_relative 'ast_nodes'

class ReturnSignal < StandardError
  attr_reader :value

  def initialize(value)
    super()
    @value = value
  end
end

class BreakSignal < StandardError; end
class ContinueSignal < StandardError; end
class InputRequest < StandardError
  attr_reader :prompt

  def initialize(prompt)
    super()
    @prompt = prompt
  end
end

class Interpreter
  def initialize(input_provider = nil)
    @global_env = Environment.new
    @classes = {}
    @functions = {}
    @output = []
    @input_provider = input_provider || method(:default_input)
  end

  def execute(program_node)
    @output = []

    begin
      execute_block(program_node.statements, @global_env)
      { success: true, output: @output.join("\n") }
    rescue InputRequest => e
      { success: false, needs_input: true, prompt: e.prompt, output: @output.join("\n") }
    rescue => e
      { success: false, error: e.message }
    end
  end

  private

  def execute_block(statements, env)
    statements.each do |statement|
      execute_statement(statement, env)
    end
  end

  def execute_statement(node, env)
    case node
    when SetStatement
      env.set(node.variable, evaluate_expression(node.value, env))
    when PrintStatement
      @output << format_output(evaluate_expression(node.expression, env))
    when IfStatement
      if truthy?(evaluate_expression(node.condition, env))
        execute_block(node.if_body, env)
      else
        branch = node.elsif_branches.find { |condition, _| truthy?(evaluate_expression(condition, env)) }
        if branch
          execute_block(branch[1], env)
        else
          execute_block(node.else_body, env)
        end
      end
    when WhileStatement
      while truthy?(evaluate_expression(node.condition, env))
        begin
          execute_block(node.body, env)
        rescue ContinueSignal
          next
        rescue BreakSignal
          break
        end
      end
    when ForStatement
      start_val = evaluate_expression(node.start_value, env)
      end_val = evaluate_expression(node.end_value, env)
      raise "For loop requires numeric range" unless start_val.is_a?(Numeric) && end_val.is_a?(Numeric)

      (start_val..end_val).each do |i|
        loop_env = Environment.new(env)
        loop_env.set(node.variable, i)

        begin
          execute_block(node.body, loop_env)
        rescue ContinueSignal
          next
        rescue BreakSignal
          break
        end
      end
    when ClassDefinition
      @classes[node.name] = KnockClass.new(node.name, node.attributes)
    when MethodDefinition
      raise "Class #{node.class_name} not defined" unless @classes.key?(node.class_name)

      @classes[node.class_name].add_method(node.name, node)
    when FunctionDefinition
      @functions[node.name] = node
    when CallExpression
      evaluate_call(node, env)
    when GetAttribute
      get_object(env, node.object).get_attribute(node.attribute)
    when SetAttribute
      get_object(env, node.object).set_attribute(node.attribute, evaluate_expression(node.value, env))
    when PushStatement
      get_array(env, node.array) << evaluate_expression(node.value, env)
    when PopStatement
      get_array(env, node.array).pop
    when SetIndexStatement
      array = get_array(env, node.array)
      index = evaluate_expression(node.index, env)
      raise "Array index must be numeric" unless index.is_a?(Numeric)

      array[index.to_i] = evaluate_expression(node.value, env)
    when DictionarySetStatement
      dictionary = get_dictionary(env, node.dictionary)
      dictionary[evaluate_key_like(node.key, env).to_s] = evaluate_expression(node.value, env)
    when RemoveValueStatement
      collection = env.get(node.array)

      case collection
      when Array
        value = evaluate_expression(node.value, env)
        remove_index = collection.index(value)
        collection.delete_at(remove_index) if remove_index
      when Hash
        collection.delete(evaluate_key_like(node.value, env).to_s)
      else
        raise "#{node.array} is not a removable collection"
      end
    when ReturnStatement
      raise ReturnSignal.new(evaluate_expression(node.expression, env))
    when BreakStatement
      raise BreakSignal
    when ContinueStatement
      raise ContinueSignal
    when TryCatchStatement
      begin
        execute_block(node.try_body, env)
      rescue ReturnSignal, BreakSignal, ContinueSignal
        raise
      rescue => _e
        execute_block(node.catch_body, env)
      end
    else
      raise "Unknown statement type: #{node.class}"
    end
  end

  def evaluate_expression(node, env)
    case node
    when Literal
      node.value
    when Variable
      env.get(node.name)
    when BinaryOperation
      left = evaluate_expression(node.left, env)
      right = evaluate_expression(node.right, env)

      case node.operator
      when '+' then left + right
      when '-' then left - right
      when '*' then left * right
      when '/'
        raise "Division by zero" if right == 0

        left / right
      when '>' then left > right
      when '<' then left < right
      when '==' then left == right
      when '!=' then left != right
      else
        raise "Unknown operator: #{node.operator}"
      end
    when UnaryOperation
      operand = evaluate_expression(node.operand, env)
      case node.operator
      when 'not' then !truthy?(operand)
      else
        raise "Unknown unary operator: #{node.operator}"
      end
    when NewInstance
      raise "Class #{node.class_name} not defined" unless @classes.key?(node.class_name)

      args = node.arguments.transform_values { |expr| evaluate_expression(expr, env) }
      @classes[node.class_name].instantiate(args)
    when CallExpression
      evaluate_call(node, env)
    when GetAttribute
      get_object(env, node.object).get_attribute(node.attribute)
    when ArrayLiteral
      node.elements.map { |element| evaluate_expression(element, env) }
    when DictionaryLiteral
      node.entries.transform_values { |value| evaluate_expression(value, env) }
    when LengthExpression
      evaluate_expression(node.array, env).length
    when IndexExpression
      array = evaluate_expression(node.array, env)
      index = evaluate_expression(node.index, env)
      raise "Can only index arrays" unless array.is_a?(Array)
      raise "Array index must be numeric" unless index.is_a?(Numeric)

      array[index.to_i]
    when DictionaryGetExpression
      dictionary = evaluate_expression(node.dictionary, env)
      raise "Can only lookup keys on dictionaries" unless dictionary.is_a?(Hash)

      dictionary[evaluate_key_like(node.key, env).to_s]
    when IncludesExpression
      collection = evaluate_expression(node.array, env)

      case collection
      when Array
        collection.include?(evaluate_expression(node.value, env))
      when Hash
        collection.key?(evaluate_key_like(node.value, env).to_s)
      else
        raise "Can only search arrays or dictionaries"
      end
    when InputExpression
      prompt = format_output(evaluate_expression(node.prompt, env))
      @input_provider.call(prompt)
    else
      raise "Unknown expression type: #{node.class}"
    end
  end

  def evaluate_call(node, env)
    if node.object
      object = get_object(env, node.object)
      method_def = object.class_def.methods[node.name]
      raise "Method #{node.name} not defined for class #{object.class_def.name}" unless method_def

      method_env = Environment.new(env)
      object.attributes.each { |attr_name, attr_value| method_env.set(attr_name, attr_value) }
      bind_parameters(method_env, method_def.parameters, node.arguments, env)

      value = execute_callable(method_def.body, method_env)
      object.attributes.each_key do |attr_name|
        object.attributes[attr_name] = method_env.get(attr_name) if method_env.defined?(attr_name)
      end
      value
    else
      function_def = @functions[node.name]
      raise "Function #{node.name} not defined" unless function_def

      function_env = Environment.new(env)
      bind_parameters(function_env, function_def.parameters, node.arguments, env)
      execute_callable(function_def.body, function_env)
    end
  end

  def bind_parameters(call_env, parameters, arguments, caller_env)
    raise "Expected #{parameters.length} arguments, got #{arguments.length}" unless parameters.length == arguments.length

    parameters.zip(arguments).each do |parameter, argument|
      call_env.set(parameter, evaluate_expression(argument, caller_env))
    end
  end

  def execute_callable(body, env)
    execute_block(body, env)
    nil
  rescue ReturnSignal => signal
    signal.value
  end

  def get_object(env, name)
    object = env.get(name)
    raise "#{name} is not an object" unless object.is_a?(KnockObject)

    object
  end

  def get_array(env, name)
    array = env.get(name)
    raise "#{name} is not an array" unless array.is_a?(Array)

    array
  end

  def get_dictionary(env, name)
    dictionary = env.get(name)
    raise "#{name} is not a dictionary" unless dictionary.is_a?(Hash)

    dictionary
  end

  def truthy?(value)
    value != false && !value.nil?
  end

  def evaluate_key_like(node, env)
    return node.name if node.is_a?(Variable) && !env.defined?(node.name)

    evaluate_expression(node, env)
  end

  def format_output(value)
    case value
    when String
      value
    when Array
      "[#{value.map { |element| format_output(element) }.join(', ')}]"
    when Hash
      "{#{value.map { |key, element| "#{key}: #{format_output(element)}" }.join(', ')}}"
    when KnockObject
      value.to_s
    when NilClass
      'nil'
    else
      value.to_s
    end
  end

  def default_input(prompt)
    if $stdin.tty?
      print(prompt.empty? ? '' : "#{prompt} ")
      $stdout.flush
      ($stdin.gets || '').chomp
    else
      raise InputRequest.new(prompt)
    end
  end
end
