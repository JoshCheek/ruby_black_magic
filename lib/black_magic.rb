require 'rbconfig'
dlext = RbConfig::CONFIG['DLEXT']
require "black_magic.#{dlext}"

require 'object_model'

module BlackMagic
  def self.for_object(obj)
    BlackMagic::Object.new obj
  end

  def self.for_class(klass)
    BlackMagic::Class.new klass
  end

  def self.get_ivars(object)
    @get_ivars ||= Kernel.instance_method :instance_variables
    @get_ivars.bind(object).call.each_with_object({}) { |name, h| h[name] = get_ivar(object, name) }
  end

  def self.get_method(klass, name)
    @get_method ||= Module.instance_method :instance_method
    @get_method.bind(klass).call(name)
  end

  def self.set_method(klass, name, body)
    @set_method ||= Module.instance_method :define_method
    @set_method.bind(klass).call(name, &body)
  end

  class IncludedClass
    attr_reader :module
    def initialize(_module)
      @module = _module
    end
  end

  class Object
    def initialize(object)
      self.object = object
    end

    def class
      BlackMagic.real_class object
    end

    def class=(klass)
      BlackMagic.set_class object, klass
    end

    def [](name)
      BlackMagic.get_ivar object, name
    end

    def []=(name, value)
      BlackMagic.set_ivar object, name, value
    end

    def ivars
      BlackMagic.get_ivars object
    end

    def to_h
      {class: self.class, ivars: self.ivars}
    end

    private

    attr_accessor :object
  end


  class Class
    def initialize(klass)
      @klass = klass
    end

    def superclass
      BlackMagic.real_superclass klass
    end

    def superclass=(new_superclass)
      BlackMagic.set_superclass klass, new_superclass
    end

    def [](name)
      BlackMagic.get_method klass, name
    end

    def []=(name, body)
      BlackMagic.set_method klass, name, body
    end

    private

    attr_reader :klass
  end
end
