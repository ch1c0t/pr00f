describe 'Object#type' do
  before :all do
    @symbol_definition = -> _wtf_lambda_ do
      instance { :ascii }
      instance { :'' }
      instance { :'symbol with spaces' }

      respond_to :all_symbols, with: [Array, of: Symbol]
      respond_to :=== do
        sig Symbol do
          with { true }
        end
        sig String do
          with { false }
        end
      end
    end
  end

  describe 'type definition' do
    it '#type' do
      expect(Symbol.type).to be_kind_of Type
    end

    it '#instances' do
      Symbol.type &@symbol_definition

      ins = Symbol.type.instances.values
      expect(ins.size).to eq 3
      ins.each do |i|
        expect(i).to be_kind_of Type::Instance
      end
    end

    it '#messages' do
      Symbol.type &@symbol_definition

      messages = Symbol.type.messages.values
      expect(messages.size).to eq 2
      messages.each do |m|
        expect(m).to be_kind_of Type::Message
      end
    end
  end

  describe 'type checking' do
  end

  after :each do
    Symbol.type = nil
  end
end
