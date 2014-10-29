module Pr00f
  class Type
    class SignatureTest < Test
      attr_reader   :input
      attr_accessor :output

      def initialize **kwargs
        @input = {}
        super()
      end

      def arity
        @input.values.compact.size
      end
      
      def check(method_name:, this:)
        test = case arity
        when 0
          actual_value = this.send method_name

          case output[0]
          when :type
            type = output[1]
            Test.new do
              actual_value.is_a? type
            end
          when :value
            prescribed_value = output[1]
            Test.new do
              actual_value == prescribed_value
            end
          end
        when 1
          if args = @input[:array]
            if args.size == 1
              ins = Type[args[0][1]].instances.values
              ous = ins.map { |i| this.send method_name, i.value }

              if output[0] == :value
                Test.new do
                  ous.all? { |o| o == output[1] }
                end
              end
            end
          end
        when 2
        when 3
        end

        test.passed? # without this line @fail_message is nil, because the Test is lazy and not gonna run without request
        fail_message test.fail_message
        @status = test.passed? ? :passed : :failed
      end
    end
  end
end
