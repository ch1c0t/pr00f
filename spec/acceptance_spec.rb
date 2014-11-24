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

    it 'can access locals from outside type scope' do
      var = :var
      Symbol.type do
        instance { var }
      end
      expect(Symbol.type.instances.values.first).to be_kind_of Type::Instance
      expect(Symbol.type.instances.values.first.value).to eq :var
    end
  end

  describe 'type checking' do
    describe 'bare' do
      it :positive do
        Symbol.type do
          instance { :first }
          instance { :second }
          respond_to :all_symbols
          respond_to :===
        end

        expect(Symbol.type.ok?).to eq true
        expect(Symbol.type.instances.all? { |_id, i| i.ok? }).to eq true
        expect(Symbol.type.messages.all? { |_id, m| m.ok? }).to eq true
      end

      it :negative_instance do
        Symbol.type do
          instance { :first }
          instance :which_raises_an_exception do raise "because fuck you, that's why" end
          respond_to :all_symbols
          respond_to :===
        end

        expect(Symbol.type.ok?).to eq false
        expect(Symbol.type.messages.all? { |_id, m| m.ok? }).to eq true

        expect(Symbol.type.instances.all? { |_id, i| i.ok? }).to eq false
        negative_instances = Symbol.type.instances.reject { |_, i| i.ok? }
        expect(negative_instances.size).to eq 1

        reason = "#<RuntimeError: because fuck you, that's why>"
        expect(negative_instances[:which_raises_an_exception].reason_of_failure).to eq reason
      end

      it :negative_message do
        Symbol.type do
          instance { :first }
          instance { :second }
          respond_to :all_symbols
          respond_to :nonexistent_method
        end

        expect(Symbol.type.ok?).to eq false
        expect(Symbol.type.instances.all? { |_id, i| i.ok? }).to eq true

        expect(Symbol.type.messages.all? { |_id, m| m.ok? }).to eq false
        negative_messages = Symbol.type.messages.reject { |_, i| i.ok? }
        expect(negative_messages.size).to eq 1
        
        reason = "Symbol does not respond to :nonexistent_method."
        expect(negative_messages[:nonexistent_method].reason_of_failure).to eq reason
      end
    end
  end

  after :each do
    Symbol.type = nil
  end
end
