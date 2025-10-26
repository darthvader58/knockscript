require_relative 'environment'
require_relative 'ast_nodes'

class Interpreter
  def initialize
    @global_env = Environment.new
    @classes = {}
    @output = []
  end
  
  def execute(program_node)
    @output = []
    
    begin
      program_node.statements.each do |statement|
        execute_statement(statement, @global_env)
      end
      { success: true, output: @output.join("\n") }
    rescue => e
      { success: false, error: e.message }
    end
  end
  
  private
  
  def execute_statement(node, env)
    case node
    when SetStatement
      value = evaluate_expression(node.value, env)
      env.set(node.variable, value)
      
    when PrintStatement
      value = evaluate_expression(node.expression, env)
      @output << format_output(value)
      
    when IfStatement
      condition_result = evaluate_expression(node.condition, env)
      if truthy?(condition_result)
        node.if_body.each { |stmt| execute_statement(stmt, env) }
      else
        node.else_body.each { |stmt| execute_statement(stmt, env) }
      end
      
    when WhileStatement
      while truthy?(evaluate_expression(node.condition, env))
        node.body.each { |stmt| execute_statement(stmt, env) }
      end
      
    when ForStatement
      start_val = evaluate_expression(node.start_value, env)
      end_val = evaluate_expression(node.end_value, env)
      
      raise "For loop requires numeric range" unless start_val.is_a?(Numeric) && end_val.is_a?(Numeric)
      
      (start_val..end_val).each do |i|
        local_env = Environment.new(env)
        local_env.set(node.variable, i)
        node.body.each { |stmt| execute_statement(stmt, local_env) }
      end
      
    when ClassDefinition
      knock_class = KnockClass.new(node.name, node.attributes)
      @classes[node.name] = knock_class
      
    when MethodDefinition
      unless @classes.key?(node.class_name)
        raise "Class #{node.class_name} not defined"
      end
      @classes[node.class_name].add_method(node.name, node)
      
    when MethodCall
      object = env.get(node.object)
      raise "#{node.object} is not an object" unless object.is_a?(KnockObject)
      
      method_def = object.class_def.methods[node.method_name]
      raise "Method #{node.method_name} not defined for class #{object.class_def.name}" unless method_def
      
      # Create method environment with access to instance attributes
      method_env = Environment.new(env)
      object.attributes.each do |attr_name, attr_value|
        method_env.set(attr_name, attr_value)
      end
      
      method_def.body.each { |stmt| execute_statement(stmt, method_env) }
      
      # Update object attributes from method environment
      object.attributes.each_key do |attr_name|
        if method_env.defined?(attr_name)
          object.attributes[attr_name] = method_env.get(attr_name)
        end
      end
      
    when GetAttribute
      object = env.get(node.object)
      raise "#{node.object} is not an object" unless object.is_a?(KnockObject)
      object.get_attribute(node.attribute)
      
    when SetAttribute
      object = env.get(node.object)
      raise "#{node.object} is not an object" unless object.is_a?(KnockObject)
      value = evaluate_expression(node.value, env)
      object.set_attribute(node.attribute, value)
      
    when PushStatement
      array = env.get(node.array)
      raise "#{node.array} is not an array" unless array.is_a?(Array)
      value = evaluate_expression(node.value, env)
      array.push(value)
      
    when PopStatement
      array = env.get(node.array)
      raise "#{node.array} is not an array" unless array.is_a?(Array)
      array.pop
      
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
      when '+'
        left + right
      when '-'
        left - right
      when '*'
        left * right
      when '/'
        raise "Division by zero" if right == 0
        left / right
      when '>'
        left > right
      when '<'
        left < right
      when '=='
        left == right
      when '!='
        left != right
      else
        raise "Unknown operator: #{node.operator}"
      end
      
    when UnaryOperation
      operand = evaluate_expression(node.operand, env)
      
      case node.operator
      when 'not'
        !truthy?(operand)
      else
        raise "Unknown unary operator: #{node.operator}"
      end
      
    when NewInstance
      unless @classes.key?(node.class_name)
        raise "Class #{node.class_name} not defined"
      end
      
      # Evaluate all argument expressions
      evaluated_args = {}
      node.arguments.each do |attr_name, attr_expr|
        evaluated_args[attr_name] = evaluate_expression(attr_expr, env)
      end
      
      @classes[node.class_name].instantiate(evaluated_args)
      
    when GetAttribute
      object = env.get(node.object)
      raise "#{node.object} is not an object" unless object.is_a?(KnockObject)
      object.get_attribute(node.attribute)
      
    when ArrayLiteral
      node.elements.map { |elem| evaluate_expression(elem, env) }
      
    else
      raise "Unknown expression type: #{node.class}"
    end
  end
  
  def truthy?(value)
    value != false && value != nil
  end
  
  def format_output(value)
    case value
    when String
      value
    when Array
      "[#{value.map { |v| format_output(v) }.join(', ')}]"
    when KnockObject
      value.to_s
    else
      value.to_s
    end
  end
end