require_relative './helper'

describe Test do
  it 'passes' do
    t = Test.new { true }

    expect(t.passed?).to eq true
    expect(t.failed?).to eq false
  end

  it 'fails' do
    t = Test.new { false }

    expect(t.passed?).to eq false
    expect(t.failed?).to eq true
  end

  it 'allows to set a fail message' do
    t = Test.new do
      fail_message 'epic fail'
      false
    end

    expect(t.fail_message).to eq 'epic fail'
  end
  
  it 'can call methods from code context' do
    m = Module.new do
      extend self

      def some_method
        true
      end

      def test
        Test.new do
          some_method
          fail_message 'fail'
          true
        end
      end
    end

    expect(m.test.passed?).to eq true
  end
end
