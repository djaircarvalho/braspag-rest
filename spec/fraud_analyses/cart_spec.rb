require 'spec_helper'

describe BraspagRest::FraudAnalyses::Cart do
  let(:braspag_response) {
    {
      'Items' => []
    }
  }

  describe '.new' do
    subject(:cart) { BraspagRest::FraudAnalyses::Cart.new(braspag_response) }

    it 'initializes a cart using braspag response format' do
      expect(cart.items).to be_an_instance_of(Array)
    end
  end
end
