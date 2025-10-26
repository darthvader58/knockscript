class Environment
    def initialize(parent = nil)
      @variables = {}
      @parent = parent
    end
    
    def get(name)
      if @variables.key?(name)
        @variables[name]
      elsif @parent
        @parent.get(name)
      else
        raise "Undefined variable: #{name}"
      end
    end
    
    def set(name, value)
      @variables[name] = value
    end
    
    def update(name, value)
      if @variables.key?(name)
        @variables[name] = value
      elsif @parent
        @parent.update(name, value)
      else
        raise "Cannot update undefined variable: #{name}"
      end
    end
    
    def defined?(name)
      @variables.key?(name) || (@parent && @parent.defined?(name))
    end
  end
  
  class KnockObject
    attr_reader :class_def, :attributes
    
    def initialize(class_def, attributes)
      @class_def = class_def
      @attributes = attributes
    end
    
    def get_attribute(name)
      if @attributes.key?(name)
        @attributes[name]
      else
        raise "Undefined attribute: #{name}"
      end
    end
    
    def set_attribute(name, value)
      if @class_def.attributes.include?(name)
        @attributes[name] = value
      else
        raise "Class #{@class_def.name} does not have attribute: #{name}"
      end
    end
    
    def to_s
      "<#{@class_def.name} instance>"
    end
  end
  
  class KnockClass
    attr_reader :name, :attributes, :methods
    
    def initialize(name, attributes)
      @name = name
      @attributes = attributes
      @methods = {}
    end
    
    def add_method(method_name, method_def)
      @methods[method_name] = method_def
    end
    
    def instantiate(arguments)
      # Create instance with attributes
      attrs = {}
      @attributes.each do |attr|
        if arguments.key?(attr)
          attrs[attr] = arguments[attr]
        else
          attrs[attr] = nil
        end
      end
      KnockObject.new(self, attrs)
    end
  end