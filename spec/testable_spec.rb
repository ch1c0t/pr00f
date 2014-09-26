require_relative './helper'
require 'ostruct'

describe Testable do
  it 'defines :respond_to' do
    c = Class.new
    c.prepend Testable

    expect(c.new).to respond_to :respond_to
  end

  context :respond_to do
    before :each do
      c = Class.new do
        prepend Testable

        def initialize
          @this = OpenStruct.new present_method: :value
        end
      end

      @i = c.new
    end

    it 'passes if its symbol refers to a present method' do
      @i.respond_to :present_method

      expect(@i.tests.size).to eq 1 
      expect(@i.tests[0]).to be_kind_of Test
      expect(@i.tests[0].passed?).to eq true
    end

    it 'fails if its symbol refers to an absent method' do
      @i.respond_to :absent_method

      expect(@i.tests.size).to eq 1 
      expect(@i.tests[0]).to be_kind_of Test
      expect(@i.tests[0].failed?).to eq true
    end
  end
end
