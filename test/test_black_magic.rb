require 'black_magic'

describe 'BlackMagic' do
  def bm_obj(obj)
    BlackMagic.for_object obj
  end

  describe 'Object' do
    it 'blows up if the object is a special object (has a specific C structure)'

    specify '#class gets the value at the object\'s class pointer' do
      o  = Object.new
      bm = bm_obj(o)

      assert_equal Object, bm.class
      def o.mg; end
      assert_equal o.singleton_class, bm.class
    end

    specify '#class= sets the object\'s class pointer' do
      class1   = Class.new
      class2   = Class.new
      instance = class1.new

      assert_equal class1, bm_obj(instance).class
      bm_obj(instance).class = class2
      assert_equal class2, instance.class
    end

    specify '#[] gets an instance variable by name' do
      o  = Object.new
      bm = bm_obj(o)

      assert_equal nil, o.instance_variable_get(:@abc)
      o.instance_variable_set(:@abc, 123)
      assert_equal 123, bm[:@abc]
    end

    specify '#[]= sets an instance variable by name' do
      o  = Object.new
      bm = bm_obj(o)

      assert_equal nil, o.instance_variable_get(:@abc)
      bm[:@abc] = 123
      assert_equal 123, o.instance_variable_get(:@abc)
    end

    specify '#ivars returns a hash of instance variables' do
      # check up to 4 values, b/c it swaps how it stores them after 3
      # https://github.com/ruby/ruby/blob/b06258f51cb7f93c179656a7af562746f5368400/include/ruby/ruby.h#L791
      o = Object.new
      bm = bm_obj(o)

      assert_equal({class: Object, ivars: {}}, bm.to_h)

      def o.mg; end
      o.instance_variable_set :@a, 1
      assert_equal({:@a => 1}, bm.ivars)

      o.instance_variable_set :@b, 2
      assert_equal({:@a => 1, :@b => 2}, bm.ivars)

      o.instance_variable_set :@c, 3
      assert_equal({:@a => 1, :@b => 2, :@c => 3}, bm.ivars)

      o.instance_variable_set :@d, 4
      assert_equal({:@a => 1, :@b => 2, :@c => 3, :@d => 4}, bm.ivars)
    end


    specify '#to_h returns a hash of the real class and instance variables' do
      o = Object.new
      bm = bm_obj(o)

      assert_equal({class: Object, ivars: {}}, bm.to_h)
      def o.mg; end
      o.instance_variable_set :@a, 1
      assert_equal({class: o.singleton_class, ivars: {:@a => 1}}, bm.to_h)
    end
  end

  describe 'Class' do
    it 'blows up if the object is not a Class'
    specify '#superclass gets the value at the class\'s superclass pointer'
    specify '#superclass= sets the value at the class\'s superclass pointer'
    specify '#[] gets an instance method'
    specify '#[]= sets an instance method'
  end
end
