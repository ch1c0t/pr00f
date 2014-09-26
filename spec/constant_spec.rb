require_relative './helper'

describe Constant do
  describe 'invalid specification' do
    it 'raises an error' do
      expect { Constant.from_string 'invalid spec' }.to raise_error Constant::InvalidSpecError
    end
  end

  context Object do
    before :all do
      @constant = Constant.from_string IO.read "#{__dir__}/core/object.rb"
    end

    it 'has one passed test' do
      expect(@constant.passed_tests.size).to eq 1
    end
  end

  context Constant do
    before :all do
      @constant = Constant.from_string IO.read "#{__dir__}/meta/constant.rb"
    end

    it 'has no failed tests' do
      expect(@constant.failed_tests.size).to eq 0
    end
  end
end
