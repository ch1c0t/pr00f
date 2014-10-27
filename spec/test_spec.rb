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
    local_variable = 'local'
    t = Test.new do
      fail_message "#{local_variable} epic fail"
      false
    end

    t.failed?
    expect(t.fail_message).to eq 'local epic fail'
  end
  
  M = Module.new do
    extend self

    def test
      Test.new do
        some_public_method
        some_private_method

        fail_message 'fail'
        true
      end
    end

    def some_public_method; end
    private def some_private_method; end
  end

  it 'can call methods from code context' do
    expect(M.test.passed?).to eq true
  end
end
