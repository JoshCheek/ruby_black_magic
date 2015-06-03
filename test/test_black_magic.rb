require 'black_magic'

describe 'BlackMagic' do
  def bm_obj(obj)
    BlackMagic.for_object obj
  end

  def bm_cls(klass)
    BlackMagic.for_class klass
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

    describe '#superclass' do
      it 'gets the value at the class\'s superclass pointer' do
        assert_equal Object, bm_cls(Class.new).superclass
      end

      it 'returns a BlackMagic::IncludedClass when that\'s what the object is' do
        mod   = Module.new
        klass = Class.new { include mod }
        ic = bm_cls(klass).superclass
        assert_equal BlackMagic::IncludedClass, ic.class
        assert_equal mod, ic.module
      end
    end

    describe '#superclass=' do
      it 'sets the value at the class\'s superclass pointer' do
        c1, c2 = Class.new, Class.new

        assert_equal Object, c1.superclass
        bm_cls(c1).superclass = c2
        assert_equal c2, c1.superclass
      end

      it 'TypeErrors on non-classes'
    end

    describe '#[]' do
      it 'gets an instance method' do
        c = Class.new { def m; end }
        m = c.instance_method :m
        assert_equal m, bm_cls(c)[:m]
      end

      it 'returns nil when there isn\'t one'
    end

    describe '#[]=' do
      classmeta t:true
      it 'sets an instance method' do
        c = Class.new { def a; 1 end }
        bm_cls(c)[:b] = lambda { a + a }
        assert_equal 2, c.new.b
      end

      it 'blows up when the value doesn\'t respond to to_proc'
    end
  end
end
