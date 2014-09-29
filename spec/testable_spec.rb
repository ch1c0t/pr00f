require_relative './helper'
require 'ostruct'

describe Testable do
  it 'defines :respond_to' do
    c = Class.new
    c.prepend Testable

    expect(c.new).to respond_to :respond_to
  end

  class A
    prepend Testable
    def initialize
      @this = OpenStruct.new present_method: :value
    end
  end

  context :respond_to do
    before :each do
      @a = A.new
    end
    it 'passes if its symbol refers to a present method' do
      @a.respond_to :present_method
      methods = @a.instance_variable_get :@methods

      expect(methods.size).to eq 1 
      expect(methods.first).to be_kind_of Test
      expect(methods.first.passed?).to eq true
    end

    it 'fails if its symbol refers to an absent method' do
      @a.respond_to :absent_method
      methods = @a.instance_variable_get :@methods

      expect(methods.size).to eq 1 
      expect(methods.first).to be_kind_of Test
      expect(methods.first.failed?).to eq true
    end
  end
end
