require 'rbconfig'
dlext = RbConfig::CONFIG['DLEXT']
require "black_magic.#{dlext}"

require 'object_model'

module BlackMagic
  def self.for_object(obj)
    BlackMagic::Object.new obj
  end

  def self.get_ivar(object, name)
    @get_ivar ||= Kernel.instance_method :instance_variable_get
    @get_ivar.bind(object).call(name)
  end

  def self.set_ivar(object, name, value)
    @set_ivar ||= Kernel.instance_method :instance_variable_set
    @set_ivar.bind(object).call(name, value)
  end

  def self.get_ivars(object)
    @get_ivars ||= Kernel.instance_method :instance_variables
    @get_ivars.bind(object).call.each_with_object({}) { |name, h| h[name] = get_ivar(object, name) }
  end

  class Object
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
end
