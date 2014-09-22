require_relative './helper'

class Object
  def constant constant, &b
    Pr00f::Constant.new constant, &b
  end
end

describe Constant do
  context Object do
    before :all do
      @constant = eval IO.read "#{__dir__}/core/object.rb"
    end

    it 'has one passed test' do
      expect(@constant.passed_tests.size).to eq 1
    end
  end

  context Constant do
    before :all do
      @constant = eval IO.read "#{__dir__}/meta/constant.rb"
    end

    it 'has no failed tests' do
      expect(@constant.failed_tests.size).to eq 0
    end
  end
end
