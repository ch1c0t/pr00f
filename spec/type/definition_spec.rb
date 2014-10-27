require_relative '../helper'

describe Type::Definition do
  D = Type::Definition

  it 'can check that some methods are defined' do
    definition = D.new Symbol do
      respond_to :all_symbols
      respond_to :absent
    end

    expect(definition.method_tests.size).to eq 2
    expect(definition.method_tests[:all_symbols].passed?).to eq true
    expect(definition.method_tests[:absent].passed?).to eq false
  end

  describe 'can check a type of returned value passed thru #with' do
    it do
      definition = D.new Symbol do
        respond_to :all_symbols do with Array end
      end

      test = definition.method_tests[:all_symbols]

      expect(test.passed?).to eq true
      expect(test.signatures.size).to eq 1
      expect(test.signatures.first.passed?).to eq true
    end

    it do
      definition = D.new Symbol do
        respond_to :all_symbols do with Symbol end
      end

      test = definition.method_tests[:all_symbols]

      expect(test.passed?).to eq false
      expect(test.signatures.size).to eq 1
      expect(test.signatures.first.passed?).to eq false
    end
  end

  describe 'can check a value of returned value passed thru #with' do
    it do
      definition = D.new Symbol do
        respond_to :to_s do
          with { 'Symbol' }
        end
      end

      test = definition.method_tests[:to_s]

      expect(test.passed?).to eq true
      expect(test.signatures.size).to eq 1
      expect(test.signatures.first.passed?).to eq true
    end

    it do
      definition = D.new Symbol do
        respond_to :to_s do
          with { 'invalid ololo' }
        end
      end

      test = definition.method_tests[:to_s]

      expect(test.passed?).to eq false
      expect(test.signatures.size).to eq 1
      expect(test.signatures.first.passed?).to eq false
    end
  end

  describe 'can check a method with multiple signatures' do
    it do
      definition = D.new Symbol do
        respond_to :=== do
          sig Symbol do with { true } end
          sig String do with { false } end
        end
      end

      expect(definition.method_tests.values.all? &:passed?).to eq true
      expect(definition.method_tests[:===].passed?).to eq true
      expect(definition.method_tests[:===].signatures.size).to eq 2
    end
  end
end
