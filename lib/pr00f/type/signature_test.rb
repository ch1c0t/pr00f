module Pr00f
  class Type
    class SignatureTest < Test
      attr_reader :input,
                  :output,
                  :tests,
                  :failed_tests

      def output= tuple
        @output = tuple
        @prescribed_type  = tuple[1] if tuple[0] == :type
        @prescribed_value = tuple[1] if tuple[0] == :value
      end

      def initialize
        @input = {}
        @tests = []
        super()
      end

      def arity
        @input.values.compact.size
      end
      
      def check(method_name:, this:)
        case arity
        when 0
          actual_value = this.send method_name

          check_type_of actual_value if prescribed_type
          check_value_of actual_value if prescribed_value
        when 1
          if args = @input[:array]
            args.map! do |a|
              if a[0] == :value
                [a[1]]
              elsif a[0] == :type
                Type[a[1]].instances.values.map &:value
              end
            end

            first = args.shift
            inputs = args.empty? ? first : (first.product *args)
            outputs = inputs.map { |i| this.send method_name, *i }

            outputs.each { |o| check_type_of o } if prescribed_type
            outputs.each { |o| check_value_of o } if prescribed_value
          end
        when 2
        when 3
        end

        @failed_tests = tests.select { |t| t.failed? }
        @status = if @failed_tests.empty?
                    :passed
                  else
                    fail_message "There are #{@failed_tests.size} failed test(s)."
                    :failed
                  end
      end

      private
      attr_reader :prescribed_type,
                  :prescribed_value

      def check_type_of value
        @tests << Test.new do
          value.is_a? prescribed_type
        end
      end

      def check_value_of value
        tests << Test.new do
          value == prescribed_value
        end
      end
    end
  end
end
