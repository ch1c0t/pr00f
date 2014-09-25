module Pr00f
  class BadInstanceDefinitionError < StandardError
    attr_reader :test
    def initialize message
      @error, @explanation = message.values_at :error, :explanation
      @test = Test.new { false }
    end

    def message
      @explanation
      puts
      @error
    end
  end

  class Instance
    prepend Testable

    attr_reader :name
    def initialize name: :unnamed, &definition
      @name = name

      begin
        @this = definition.call
      rescue
        # if a failure occurred so early, it would be a very little use in proceeding
        # without giving it a look first
        message = { error: $!, explanation: "An error occurred when trying to create the instance #{@name}" }
        raise BadInstanceDefinitionError.new message
      end
    end
  end
end
