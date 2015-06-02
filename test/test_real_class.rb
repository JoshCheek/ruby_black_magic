require 'object_model'

class TestRealClass < Minitest::Spec
  it 'returns the real class of the object' do
    o = Object.new
    assert_equal Object, ObjectModel.real_class(o)
    def o.zomg; end
    real_class = ObjectModel.real_class(o)
    assert_equal o.singleton_class, real_class
  end
end
