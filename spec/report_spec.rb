require_relative './helper'

describe Report do
  describe 'invalid specification' do
    it 'raises an error' do
      expect { Report.new 'invalid spec' }.to raise_error InvalidSpecError
    end
  end

  describe 'Object specification' do
    before :all do
      @report = Report.new IO.read './spec/core/object.rb'
    end

    it 'has one passed test' do
      expect(@report.passed_tests.size).to eq 1
    end

    it 'has no failed tests' do
      expect(@report.failed_tests.size).to eq 0
    end
  end
end
