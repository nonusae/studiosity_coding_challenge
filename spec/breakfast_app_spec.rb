require 'spec_helper'
require 'breakfast_app'
require 'json'

describe 'Breakfast App' do
  let(:price_list_json) do
    [
      { "id": "flat-white", name: "Flat White", price: 3.0 },
      { "id": "espresso", name: "Espresso", price: 2.0 },
      { "id": "bacon-egg-roll", name: "Bacon & Egg Roll", price: 5.0 },
      { "id": "bbq-sauce", name: "BBQ Sauce", price: 0.0 },
    ].to_json
  end

  let(:orders_json) do
    [
      { "name": "dave", "money": 10.0, "items": ["flat-white", "bacon-egg-roll", "bbq-sauce"] },
      { "name": "jenny", "money": 5.0, "items": ["espresso"] },
      { "name": "Josh", "money": 2.0, "items": ["flat-white", "bacon-egg-roll"] }
    ].to_json
  end

  let(:result_json) do
    [
      { "name": "dave", change: 2.0 , status: 'success' },
      { "name": "jenny", change: 3.0 , status: 'success' },
      { "name": "Josh", change: 2.0, status: 'fail', error: 'Insufficient Money.' },
    ].to_json
  end

  before do
    json_result = BreakfastApp.call(price_list_json, orders_json)
    @result = JSON.load(json_result)
  end

  it 'should match the expected result' do
    expect(@result).to eq(JSON.load(result_json))
  end

  it 'should contain 2 records' do
    expect(@result.count).to eq 3
  end

  it 'should provide the correct change' do
    expect(@result[0]['change']).to eq 2.0
    expect(@result[1]['change']).to eq 3.0
  end

  it 'should return full money when order price is more than money' do
    expect(@result[2]['change']).to eq 2.0
    expect(@result[2]['status']).to eq 'fail'
    expect(@result[2]['error']).to eq 'Insufficient Money.'
  end
end
