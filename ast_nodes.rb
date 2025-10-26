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
    attr_accessor :condition, :if_body, :else_body
    
    def initialize(condition, if_body, else_body = [])
      super()
      @condition = condition
      @if_body = if_body
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
  
  class NewInstance < ASTNode
    attr_accessor :class_name, :arguments
    
    def initialize(class_name, arguments)
      super()
      @class_name = class_name
      @arguments = arguments
    end
  end
  
  class MethodCall < ASTNode
    attr_accessor :method_name, :object
    
    def initialize(method_name, object)
      super()
      @method_name = method_name
      @object = object
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