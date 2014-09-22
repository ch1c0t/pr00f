module Pr00f
  class Instance
    include CommonCheckers

    attr_reader :object, :name, :tests
    def initialize name: :unnamed, &b
      @object = self
      @name = name

      @tests = []

      begin
        @object = b.call
      rescue
        # TODO: Give a bit more helpful information here.
        raise "An error occurred when trying to create the instance #{@name}. #{$!.inspect}"
      end
    end
  end
end
