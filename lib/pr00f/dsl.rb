module Pr00f
  module DSL
    extend self

    def run string
      module_eval string
      puts 'Everything seems to be okay.'
    end

    def constant constant, &b
      Constant.new constant, &b
    end
  end
end
