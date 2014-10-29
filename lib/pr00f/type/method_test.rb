require_relative './signature_test'

module Pr00f
  class Type
    class MethodTest < Test
      attr_reader :signatures
      def initialize method_name, this
        @method_name = method_name
        @this = this

        super()
      end

      def existential_test
        @existential_test ||= Test.new do
          fail_message "#{this} is supposed to have :#{method_name} defined, which doesn't seem to be the case."
          this.respond_to? method_name
        end
      end

      def check_signatures &description
        @signatures = []
        instance_eval &description
      end

      private
      attr_reader :method_name, :this

      def sig type
        @current_signature = SignatureTest.new
        @current_signature.input[:array] = [[:type, type]]
        yield
        @current_signature = nil
      end

      def with type = nil
        signature = @current_signature || SignatureTest.new

        if block_given?
          signature.output = [:value, yield]
        else
          signature.output = [:type, type]
        end

        signature.check method_name: method_name, this: this
        @signatures << signature
      end

      def check
        @status = ([*@existential_test, *@signatures].all? &:passed?) ? :passed : :failed
      end
    end
  end
end
