module Pr00f
  class Type
    require_relative './type/instance'
    require_relative './type/method_test'
    require_relative './type/definition'

    @@types = {}
    @@definitions = Hash.new { |h,k| h[k] = [] }

    class << self
      def [] type
        @@types[type]
      end

      def []= type, value
        @@types[type] = value
        @@definitions[type].clear
      end

      # Deletes all definitions except the first
      def reload type
        @@definitions[type] = [@@definitions[type].first]
      end
    end

    [:instances, :method_tests].each do |getter|
      define_method getter do
        (@@definitions[@type].map &getter).inject &:merge
      end
    end

    def initialize type, &definition
      definition = Definition.new type, &definition
      @@definitions[type] << definition

      @type = type
      @@types[type] ||= self
    end
  end

  Type.new Symbol do
    instance { :ascii }
    instance { :'' }
    instance { :'symbol with spaces' }
  end
  Type.new Array do
    instance { [] }
    instance { [Object, Object.new, :symbol, 'string', 42] }
  end
  Type.new String do
    instance { 'string' }
    instance { '' }
    instance { 'string with spaces' }
  end
  Type.new Integer do
    instance { 0 }
    instance { 1 }
    instance { 42 }
  end
end
