require_relative './helper'

describe Instance do
  it 'raises an error on inappropriate definition' do
    expect { Instance.new { 1/0 } }.to raise_error BadInstanceDefinitionError
  end
end
