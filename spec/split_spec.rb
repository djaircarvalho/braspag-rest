require 'spec_helper'

describe BraspagRest::Split do
  let(:braspag_response) {
    {
      'MerchantId' => 1,
      'Amount' => 50
    }
  }

  describe '.new' do
    subject(:split) { BraspagRest::Split.new(braspag_response) }

    it 'initializes an split using braspag response format' do
      expect(split.merchant_id).to eq(1)
      expect(split.amount).to eq(50)
    end
  end
end
