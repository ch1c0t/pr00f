require_relative './helper'

describe Type do
  before :all do
    T = :type
  end

  describe 'extensional definition' do
    it 'defines a type' do
      Type.new T do
        instance { Object }
        instance { Object.new }
        instance { :symbol }
        instance { 'string' }
        instance { 42 }
      end

      expect(Type[T].instances.size).to eq 5
      Type[T].instances.each do |(_name, instance)|
        expect(instance).to be_kind_of Type::Instance
      end
      expect(Type[T].instances.map { |_,v| v }.map &:value).to include :symbol
    end

    it 'defines a type with named instances' do
      Type.new T do
        instance :object do Object end
        instance :number do 42 end
      end

      expect(Type[T].instances[:object].value).to eq Object
      expect(Type[T].instances[:number].value).to eq 42
    end

    it 'allows to access defined types via Type class' do
      expect(Type[T]).to eq nil

      Type.new T
      type = Type[T]

      expect(type).to be_kind_of Type
    end

    it 'predefines some core types' do
      types = [Symbol, String, Array, Integer]
      types.each { |type| expect(Type[type]).to be_kind_of Type }
    end

    it 'allows to append type definition' do
      Type.new T do
        instance { 42 }
      end
      expect(Type[T].instances.size).to eq 1

      Type.new T do
        instance { 8 }
      end
      expect(Type[T].instances.size).to eq 2
    end

    it 'reloads core types' do
      expect(Type[Symbol]).to be_truthy
      expect(Type[Symbol].instances.size).to eq 3

      expect(Type[Symbol].method_tests[:ololo]).to eq nil
      Type.new Symbol do
        respond_to :ololo
      end
      expect(Type[Symbol].method_tests[:ololo]).to be_truthy

      Type.reload Symbol
      expect(Type[Symbol]).to be_truthy
      expect(Type[Symbol].instances.size).to eq 3
      expect(Type[Symbol].method_tests[:ololo]).to eq nil
    end
  end

  after :each do
    Type[T] = nil
    Type.reload Symbol
  end
end
