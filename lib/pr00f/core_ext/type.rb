module Pr00f
  class Type
    class << self
      CORETYPE_DEFINITION = -> do
        Symbol.type do
          instance { :ascii }
          instance { :'' }
          instance { :'symbol with spaces' }
        end

        Array.type do
          instance :empty do [] end
          instance :amalgamation do
            [Object, Object.new, :symbol, 'string', 42]
          end
        end

        String.type do
          instance { 'string' }
          instance { '' }
          instance { 'symbol with spaces' }
        end
      end

      def load_core
        CORETYPE_DEFINITION.call
      end

      def clear_core
        [Symbol, Array, String].each { |t| t.type = nil }
      end
    end

    class Instance
      attr_reader :reason_of_failure

      def value
        try unless @value
        @value
      end

      def initialize &definition
        @definition = definition
      end

      def try
        begin
          @value = @definition.call
        rescue
          @reason_of_failure = $!.inspect
        end
      end

      def ok?
        try
        @value ? true : false
      end
    end

    class Message
      class Signature
        attr_accessor :output_description
        def initialize input: [], output: nil
          @input  = input.map { |t| prepare t }
          @output = prepare output
        end

        private

        def prepare type
          (type.is_a? Proc) ? (Unit.new type) : type
        end

        def with type = nil, &value
          @output = value ? (Unit.new value) : type
        end
      end

      def initialize name: nil, signature: {}, &definition
        @name = name
        
        @signatures = []
        if signature[:input] || signature[:output]
          signature = Signature.new **signature
          @signatures << signature
        end

        instance_eval &definition if definition
      end

      def check_against receiver
        @tests = []

        if @signatures.empty?
          name = @name
          test = Test.new do
            fail_message "#{receiver} does not respond to :#{name}."
            receiver.respond_to? name
          end

          @tests << test
        else
        end
      end

      def ok?
        @tests.all? { |t| t.passed? }
      end

      def reason_of_failure
        @tests.find(&:failed?).fail_message
      end

      private

      def sig *type, &output_description
        signature = Signature.new input: type
        signature.output_description = output_description if output_description
        @signatures << signature
      end

      def with type = nil, &value
        @default_output = value ? (Unit.new value) : type
      end
    end

    class Unit
      def initialize callable
        type do
          instance { callable.call }
        end
      end
    end

    attr_reader :instances,
                :messages
    def initialize type, &definition
      create_instances
      create_messages

      @type = type
      instance_eval &definition if block_given?
    end

    def ok?
      instance_initialization = @instances.values.all? { |i| i.ok? }
      correctness_of_messages = @messages.values.all? { |m| m.check_against @type; m.ok? }

      instance_initialization && correctness_of_messages
    end

    private

    def create_instances
      @instances = {}
      def @instances.add i
        self[Random.srand] = i
      end
    end

    def create_messages
      @messages = {}
    end


    def instance name = nil, &b
      i = Instance.new &b
      name.nil? ? (@instances.add i) : (@instances[name] = i)
    end

    def respond_to name, *input_signature, with: nil, &definition
      signature = {}
      signature[:input]  = input_signature unless input_signature.empty?
      signature[:output] = with

      m = Message.new name: name, signature: signature, &definition
      @messages[name] = m
    end
  end
end
