require_relative './helper'

describe Constant do
  it 'parses a valid specification from string' do
    constant = Constant.from_string IO.read "#{__dir__}/core/object.rb"
    expect(constant.fulfill_requirements?).to eq true
  end

  it 'raises an error for invalid specification' do
    expect { Constant.from_string 'invalid spec' }.to raise_error Constant::InvalidSpecError
  end

  it 'parses bare methods' do
    constant = Constant.new Object do
      respond_to :new
      respond_to :absent
    end

    methods = constant.instance_variable_get :@methods

    expect(methods.size).to eq 2
    expect(methods[0].passed?).to eq true
    expect(methods[1].passed?).to eq false
  end
end
