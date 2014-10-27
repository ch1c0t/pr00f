module Pr00f
  class Type
    class SignatureTest < Test
      attr_accessor :input_type,
                    :output_type,
                    :output_value

      def initialize **kwargs
        @input_type = kwargs[:input_type]
        super()
      end
      
      def check(method_name:, this:)
        test = if input_type
          instances = Type[input_type].instances
          raise "Unfortunately, no instances for #{this} are available." unless instances

          instances = instances.values.map &:value
          outputs = instances.map { |i| this.send method_name, i }

          unless output_type
            Test.new do
              fail_message "After passing any of #{instances} to #{this}##{method_name}, all values in #{outputs} should be #{output_value}."
              outputs.all? { |o| o == output_value }
            end
          else
            Test.new do
              fail_message "All values in #{outputs} should be of #{output_type} type."
              outputs.all? { |o| o.is_a? output_type }
            end
          end
        else
          actual_value = this.send method_name

          unless output_type
            Test.new do
              fail_message "The value of #{this}##{method_name} should be #{output_value}, but we got #{actual_value} instead."
              actual_value == output_value
            end
          else
            Test.new do
              fail_message "The value of #{this}##{method_name} should be of type #{output_type}, but we got #{actual_value.class} instead."
              actual_value.is_a? output_type
            end
          end
        end

        test.passed? # without this line @fail_message is nil, because the Test is lazy and not gonna run without request
        fail_message test.fail_message
        @status = test.passed? ? :passed : :failed
      end
    end
  end
end
