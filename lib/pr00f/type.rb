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

    def method_tests
      @@definitions[@type].inject(&:+).method_tests
    end

    def instances
      @@definitions[@type].inject(&:+).instances.merge ancestral_instances
    end

    def initialize type, &definition
      definition = Definition.new type, &definition
      @@definitions[type] << definition

      @type = type
      @@types[type] ||= self
    end

    private

    def ancestral_instances
      if @type.is_a? Class
        defined_ancestors = @type.ancestors[1..-1].select { |a| Type[a] }
        if defined_ancestors.empty?
          {}
        else
          defined_ancestors
            .map { |a| Type[a].instances }
            .inject &:merge
        end
      else
        {}
      end
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

  Type.new Numeric do
    instance { Math::PI }
    instance { 0.5r }
    #instance { -1 }
    instance { 0 }
    instance { 1 }
    instance { 42 }
  end
  Type.new Integer do
    instance { 0 }
    instance { 1 }
    instance { 42 }
  end
end
