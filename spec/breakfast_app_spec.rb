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
      { "name": "jenny", "money": 5.0, "items": ["espresso"] }
    ].to_json
  end

  let(:result_json) do
    [
      { "name": "dave", change: 2.0 },
      { "name": "jenny", change: 3.0 },
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
    expect(@result.count).to eq 2
  end

  it 'should provide the correct change' do
    expect(@result[0]['change']).to eq 2.0
    expect(@result[1]['change']).to eq 3.0
  end

end
