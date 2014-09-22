module Pr00f
  class Instance
    include CommonCheckers

    attr_reader :this, :name, :tests
    def initialize name: :unnamed, &b
      @name  = name
      @tests = []

      begin
        @this = b.call
      rescue
        # TODO: Give a bit more helpful information here.
        raise "An error occurred when trying to create the instance #{@name}. #{$!.inspect}"
      end
    end
  end
end
