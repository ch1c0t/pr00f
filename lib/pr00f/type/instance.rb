module Pr00f
  class Type
    class Instance
      attr_reader :value
      def initialize
        @value = yield
      end
    end
  end
end
