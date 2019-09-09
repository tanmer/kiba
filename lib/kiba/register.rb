module Kiba
  module Register
    def self.included(base)
      base.extend ClassMethods
      base.instance_variable_set('@registered', Instance.new)
    end

    module ClassMethods
      def registered
        instance_variable_get(:'@registered')
      end

      %w[source transform destination].each do |m|
        define_method "register_#{m}" do |symbol, klass|
          registered.add(m.to_sym, symbol, klass)
        end
        define_method "register_#{m}s" do |hash|
          hash.each_pair { |symbol, klass | send("register_#{m}", symbol, klass) }
        end
      end
    end

    class Instance
      attr_reader :sources, :transforms, :destinations

      def initialize
        @sources = {}
        @transforms = {}
        @destinations = {}
      end

      def add(type, symbol, klass)
        value_of(type)[symbol.to_sym] = klass
      end

      def fetch(type, symbol)
        value_of(type).fetch(symbol.to_sym)
      end

      def clear
        @sources.clear
        @transforms.clear
        @destinations.clear
      end

      private

      def value_of(type)
        instance_variable_get("@#{type}s")
      end
    end
  end
end
