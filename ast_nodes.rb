class ASTNode
  attr_accessor :line

  def initialize(line = nil)
    @line = line
  end
end

class ProgramNode < ASTNode
  attr_accessor :statements

  def initialize
    super
    @statements = []
  end
end

class SetStatement < ASTNode
  attr_accessor :variable, :value

  def initialize(variable, value)
    super()
    @variable = variable
    @value = value
  end
end

class PrintStatement < ASTNode
  attr_accessor :expression

  def initialize(expression)
    super()
    @expression = expression
  end
end

class IfStatement < ASTNode
  attr_accessor :condition, :if_body, :elsif_branches, :else_body

  def initialize(condition, if_body, elsif_branches = [], else_body = [])
    super()
    @condition = condition
    @if_body = if_body
    @elsif_branches = elsif_branches
    @else_body = else_body
  end
end

class WhileStatement < ASTNode
  attr_accessor :condition, :body

  def initialize(condition, body)
    super()
    @condition = condition
    @body = body
  end
end

class ForStatement < ASTNode
  attr_accessor :variable, :start_value, :end_value, :body

  def initialize(variable, start_value, end_value, body)
    super()
    @variable = variable
    @start_value = start_value
    @end_value = end_value
    @body = body
  end
end

class ClassDefinition < ASTNode
  attr_accessor :name, :attributes, :methods

  def initialize(name, attributes)
    super()
    @name = name
    @attributes = attributes
    @methods = {}
  end
end

class MethodDefinition < ASTNode
  attr_accessor :name, :class_name, :parameters, :body

  def initialize(name, class_name, parameters, body)
    super()
    @name = name
    @class_name = class_name
    @parameters = parameters
    @body = body
  end
end

class FunctionDefinition < ASTNode
  attr_accessor :name, :parameters, :body

  def initialize(name, parameters, body)
    super()
    @name = name
    @parameters = parameters
    @body = body
  end
end

class TryCatchStatement < ASTNode
  attr_accessor :try_body, :catch_body

  def initialize(try_body, catch_body)
    super()
    @try_body = try_body
    @catch_body = catch_body
  end
end

class ReturnStatement < ASTNode
  attr_accessor :expression

  def initialize(expression)
    super()
    @expression = expression
  end
end

class BreakStatement < ASTNode
end

class ContinueStatement < ASTNode
end

class NewInstance < ASTNode
  attr_accessor :class_name, :arguments

  def initialize(class_name, arguments)
    super()
    @class_name = class_name
    @arguments = arguments
  end
end

class CallExpression < ASTNode
  attr_accessor :name, :object, :arguments

  def initialize(name, object = nil, arguments = [])
    super()
    @name = name
    @object = object
    @arguments = arguments
  end
end

class GetAttribute < ASTNode
  attr_accessor :attribute, :object

  def initialize(attribute, object)
    super()
    @attribute = attribute
    @object = object
  end
end

class SetAttribute < ASTNode
  attr_accessor :attribute, :object, :value

  def initialize(attribute, object, value)
    super()
    @attribute = attribute
    @object = object
    @value = value
  end
end

class BinaryOperation < ASTNode
  attr_accessor :left, :operator, :right

  def initialize(left, operator, right)
    super()
    @left = left
    @operator = operator
    @right = right
  end
end

class UnaryOperation < ASTNode
  attr_accessor :operator, :operand

  def initialize(operator, operand)
    super()
    @operator = operator
    @operand = operand
  end
end

class Literal < ASTNode
  attr_accessor :value

  def initialize(value)
    super()
    @value = value
  end
end

class Variable < ASTNode
  attr_accessor :name

  def initialize(name)
    super()
    @name = name
  end
end

class ArrayLiteral < ASTNode
  attr_accessor :elements

  def initialize(elements)
    super()
    @elements = elements
  end
end

class DictionaryLiteral < ASTNode
  attr_accessor :entries

  def initialize(entries)
    super()
    @entries = entries
  end
end

class PushStatement < ASTNode
  attr_accessor :value, :array

  def initialize(value, array)
    super()
    @value = value
    @array = array
  end
end

class PopStatement < ASTNode
  attr_accessor :array

  def initialize(array)
    super()
    @array = array
  end
end

class SetIndexStatement < ASTNode
  attr_accessor :index, :array, :value

  def initialize(index, array, value)
    super()
    @index = index
    @array = array
    @value = value
  end
end

class DictionarySetStatement < ASTNode
  attr_accessor :key, :dictionary, :value

  def initialize(key, dictionary, value)
    super()
    @key = key
    @dictionary = dictionary
    @value = value
  end
end

class RemoveValueStatement < ASTNode
  attr_accessor :value, :array

  def initialize(value, array)
    super()
    @value = value
    @array = array
  end
end

class LengthExpression < ASTNode
  attr_accessor :array

  def initialize(array)
    super()
    @array = array
  end
end

class IndexExpression < ASTNode
  attr_accessor :index, :array

  def initialize(index, array)
    super()
    @index = index
    @array = array
  end
end

class DictionaryGetExpression < ASTNode
  attr_accessor :key, :dictionary

  def initialize(key, dictionary)
    super()
    @key = key
    @dictionary = dictionary
  end
end

class IncludesExpression < ASTNode
  attr_accessor :value, :array

  def initialize(value, array)
    super()
    @value = value
    @array = array
  end
end

class InputExpression < ASTNode
  attr_accessor :prompt

  def initialize(prompt)
    super()
    @prompt = prompt
  end
end
