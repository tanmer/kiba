module Kiba
  module Checkpoint
    def checkpoints
      @checkpoints_store ||= Store.new
    end

    def checkpoint(name)
      transform { |row| checkpoints[name] = row }
    end

    class Store < Hash; end
  end
end
