require_relative '../helper'

describe Type::MethodTest do
  MethodTest = Type::MethodTest

  it '#existential_test' do
    test = MethodTest.new :new, Object
    expect(test.existential_test.passed?).to eq true

    test = MethodTest.new :absent, Object
    expect(test.existential_test.passed?).to eq false
  end

  describe '#check_signatures_from' do
    it do
      test = MethodTest.new :===, Symbol
      test.check_signatures do
        sig Symbol do with { true } end
        sig String do with { false } end
      end

      expect(test.signatures.size).to eq 2
      expect(test.signatures.all? &:passed?).to eq true
      expect(test.passed?).to eq true
    end
  end
end
