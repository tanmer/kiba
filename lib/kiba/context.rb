module Kiba
  class Context
    include Kiba::Checkpoint

    def initialize(control)
      @control = control
      control.context = self
    end

    def pre_process(&block)
      @control.pre_processes << { block: block }
    end

    def source(klass, *initialization_params)
      @control.sources << { klass: resolve_klass(:source, klass), args: initialization_params }
    end

    def transform(klass = nil, *initialization_params, &block)
      @control.transforms << { klass: resolve_klass(:transform, klass), args: initialization_params, block: block }
    end

    def destination(klass = nil, *initialization_params, &block)
      @control.destinations << { klass: resolve_klass(:destination, klass), args: initialization_params, block: block }
    end

    def post_process(&block)
      @control.post_processes << { block: block }
    end

    private

    def resolve_klass(type, klass)
      klass.is_a?(Symbol) || klass.is_a?(String) ? Kiba.registered.fetch(type, klass) : klass
    end
  end
end
