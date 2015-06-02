require 'object_model'

class TestRealClass < Minitest::Spec
  class HasLastName
    def initialize(last_name)
      @last_name = last_name
    end

    def name
      "Unknown #{@last_name}"
    end
  end

  class FirstnameJohn
    def name
      "John #{@last_name}"
    end
  end

  class FirstnameJane
    def name
      "Jane #{@last_name}"
    end
  end

  it 'Swaps the class, and retains the instance variables' do
    o = HasLastName.new 'Doe'
    assert_equal HasLastName,   o.class
    assert_equal "Unknown Doe", o.name

    ObjectModel.set_class o, FirstnameJohn
    assert_equal FirstnameJohn, o.class
    assert_equal "John Doe",    o.name

    ObjectModel.set_class o, FirstnameJane
    assert_equal FirstnameJane, o.class
    assert_equal "Jane Doe",    o.name
  end
end
