require 'spec_helper'
require 'breakfast_app'

describe 'Cashier' do
  context "valid order" do
    let(:order) { OpenStruct.new(name: 'john', money: 50) }
    let(:order_total) { 40 }

    it 'provide success order' do
      expect(Cashier.for(order, order_total)).to be_instance_of(SuccessOrder)
    end
  end

  context "insufficient money order" do
    let(:order) { OpenStruct.new(name: 'john', money: 10) }
    let(:order_total) { 40 }

    it 'provide success order' do
      expect(Cashier.for(order, order_total)).to be_instance_of(InsufficientMoneyOrder)
    end
  end
end
