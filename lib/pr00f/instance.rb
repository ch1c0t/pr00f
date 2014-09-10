module Pr00f
  class Instance
    include RespondToChecker

    attr_reader :name
    def initialize symbol, &b
      @name = symbol

      begin
        @object = b.call
      rescue Exception => e
        # TODO: Give a bit more helpful information here.
        p e
        raise "An error occurred when trying to create the instance #{@name}."
      end
    end
  end
end
