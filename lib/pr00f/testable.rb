module Pr00f
  module Testable
    attr_reader :this, :passed_tests, :failed_tests, :tests
    def initialize *args
      @this = nil
      @tests = []
      @methods = []

      super
    end

    def respond_to symbol
      test = Test.new do
        fail_message "#{this} is supposed to have :#{symbol} defined, which doesn't seem to be the case."
        this.respond_to? symbol
      end

      @tests << test
    end
  end
end
