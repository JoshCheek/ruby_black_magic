require 'object_model'

class TestActualSuperclass < Minitest::Spec
  def sc_of(klass)
    ObjectModel.real_superclass klass
  end

  it 'finds the actual superclass' do
    assert_equal sc_of(Class), Module

    skip 'This should be a wrapped class!'
    mod   = Module.new
    klass = Class.new { include mod }
    assert_equal sc_of(klass).wrapped, mod
  end

  it 'turns out superclass of modules and BasicObject is false (or, 0x0 in memory :P)' do
    assert_equal sc_of(BasicObject), false
    assert_equal sc_of(Kernel), false
  end
end
