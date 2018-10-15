# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BraspagRest::SplitPayment do
  let(:braspag_response) do
    {
      'SubordinateMerchantId' => '20943d1a-153f-42b6-93b8-07b9db000651',
      'Amount' => 6000,
      'Fares' => {
        'Mdr' => 2,
        'Fee' => 30
      },
      'Splits' => [
        {
          'MerchantId' => '20943d1a-153f-42b6-93b8-07b9db000651',
          'Amount' => 5850
        },
        {
          'MerchantId' => 'abf26594-b758-4a69-841d-e254285f7068',
          'Amount' => 150
        }
      ]
    }
  end

  describe '.new' do
    subject(:split_payment) { BraspagRest::SplitPayment.new(braspag_response) }

    it 'initializes an split_payment using braspag response format' do
      expect(split_payment.subordinate_merchant_id).to eq('20943d1a-153f-42b6-93b8-07b9db000651')
      expect(split_payment.amount).to eq(6000)
      expect(split_payment.fares.mdr).to eq(2)
      expect(split_payment.fares.fee).to eq(30)
      expect(split_payment.splits[0].merchant_id).to eq('20943d1a-153f-42b6-93b8-07b9db000651')
      expect(split_payment.splits[0].amount).to eq(5850)
      expect(split_payment.splits[1].merchant_id).to eq('abf26594-b758-4a69-841d-e254285f7068')
      expect(split_payment.splits[1].amount).to eq(150)
    end
  end
end
