module Pr00f
  module RespondToChecker
    def respond_to symbol
      unless @object.respond_to? symbol
        raise "#{@object} is supposed to have :#{symbol} defined, which doesn't seem to be the case."
      end
    end
  end
end
