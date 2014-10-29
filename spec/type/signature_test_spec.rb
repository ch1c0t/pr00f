require_relative '../helper'

describe Type::SignatureTest do
  let(:test) { Type::SignatureTest.new }

  describe 'nullary' do
    it do
      test.output = [:type, Array]
      test.check this: Symbol, method_name: :all_symbols

      expect(test.arity).to eq 0
      expect(test.passed?).to eq true
    end

    it do
      test.output = [:type, Symbol]
      test.check this: Symbol, method_name: :all_symbols

      expect(test.arity).to eq 0
      expect(test.passed?).to eq false
    end

    it do
      test.output = [:value, 'Symbol']
      test.check this: Symbol, method_name: :to_s

      expect(test.arity).to eq 0
      expect(test.passed?).to eq true
    end

    it do
      test.output = [:value, 'invalid output']
      test.check this: Symbol, method_name: :to_s

      expect(test.arity).to eq 0
      expect(test.passed?).to eq false
    end
  end

  describe 'unary' do
    it do
      test.input[:array] = [[:type, Symbol]]
      test.output = [:value, true]

      test.check this: Symbol, method_name: :===

      expect(test.arity).to eq 1
      expect(test.passed?).to eq true
    end

    it do
      test.input[:array] = [[:type, String]]
      test.output = [:value, false]

      test.check this: Symbol, method_name: :===

      expect(test.arity).to eq 1
      expect(test.passed?).to eq true
    end
  end
end
