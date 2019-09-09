require_relative 'helper'
require_relative 'support/test_enumerable_source'

class TestRegister < Kiba::Test
  class MultiplyTransform
    def process(x)
      x * 2
    end
  end

  class CollectinDestination
    def initialize(collector)
      @collector = collector
    end

    def write(x)
      @collector << x
    end
  end

  def test_register
    Kiba.register_sources enum: TestEnumerableSource
    Kiba.register_transforms multiply: MultiplyTransform
    Kiba.register_destinations collection: CollectinDestination

    destination_array = []
    job = Kiba.parse do
      source :enum, 1..3
      transform :multiply
      destination :collection, destination_array
    end

    Kiba.run(job)

    assert_equal [2, 4, 6], destination_array
  end
end
