require 'rbconfig'
dlext = RbConfig::CONFIG['DLEXT']
require "black_magic.#{dlext}"

require 'object_model'

module BlackMagic
  def self.for_object(obj)
    BlackMagic::Object.new obj
  end

  class Object
    attr_accessor :object

    def initialize(object)
      self.object = object
    end

    def class
      ObjectModel.real_class object
    end

    def class=(klass)
      ObjectModel.set_class object, klass
    end

    def [](name)
      Kernel.instance_method(:instance_variable_get)
            .bind(object)
            .call(name)
    end

    def []=(name, value)
      Kernel.instance_method(:instance_variable_set)
            .bind(object)
            .call(name, value)
    end

    def ivars
      Kernel.instance_method(:instance_variables)
            .bind(object)
            .call
            .each_with_object({}) { |name, h| h[name] = self[name] }
    end

    def to_h
      {class: self.class, ivars: self.ivars}
    end
  end
end
