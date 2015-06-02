require 'object_model'

class TestMethodLocations < Minitest::Spec
  it 'returns an array of the places it will visit while looking for methods, with included classes being represented' do
    locations = ObjectModel.ancestry "a"
    assert_equal String,      locations[0]
    assert_equal Comparable,  locations[1].wrapped
    assert_equal BasicObject, locations[-1]
  end
end
