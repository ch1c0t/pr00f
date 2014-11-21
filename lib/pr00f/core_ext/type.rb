module Pr00f
  class Type
    class Instance
      attr_reader :value
      def initialize
        @value = yield
      end
    end
    class Message
      def initialize name: nil, signature: nil, &definition
        @name = name
        
        @signatures = []
        (@signatures << signature) if signature

        @definition = definition
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
      signature = { input: input_signature, output: with }
      m = Message.new name: name, signature: signature, &definition
      @messages[name] = m
    end
  end
end
