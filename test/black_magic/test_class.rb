require 'black_magic'

describe 'BlackMagic::Class' do
  def bm_cls(klass)
    BlackMagic.for_class klass
  end

  describe 'Class' do
    it 'blows up if the object is not a Class'

    describe '#superclass' do
      it 'gets the value at the class\'s superclass pointer' do
        assert_equal Object, bm_cls(Class.new).superclass
        assert_equal false, bm_cls(BasicObject).superclass
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
