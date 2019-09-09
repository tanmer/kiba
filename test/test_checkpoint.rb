require_relative 'helper'
require_relative 'support/test_enumerable_source'

class TestCheckpoint < Kiba::Test
  class MultiplyTransform
    def process(x)
      x * 2
    end
  end

  class CollectinDestination
    def initialize(context, collector)
      @collector = collector
      @context = context
    end

    def write(x)
      @collector << [
        *@context.checkpoints.values_at(:source, :multiply, :add),
        x
      ]
    end
  end

  def test_checkpoint
    Kiba.register_sources enum: TestEnumerableSource
    Kiba.register_destinations collection: CollectinDestination

    destination_array = []
    my_checkpoints = nil
    job = Kiba.parse do
      source :enum, 1..3
      checkpoint :source
      transform { |x| x * 2 }
      checkpoint :multiply
      transform { |x| x + 10 }
      checkpoint :add
      transform { |x| x - 10 }
      transform { |x| checkpoints[:last] = x }
      destination :collection, self, destination_array
      destination { |x| my_checkpoints = x }
    end

    Kiba.run(job)

    assert_equal [[1, 2, 12, 2], [2, 4, 14, 4], [3, 6, 16, 6]], destination_array
    assert_equal my_checkpoints, 6
    assert_equal 6, job.checkpoints[:last]
  end
end
