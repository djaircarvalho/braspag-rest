require 'spec_helper'

describe BraspagRest::FraudAnalyses::Item do
  let(:braspag_response) {
    {
      'Name' => 'Item teste',
      'MerchantItemId' => '123',
      'Quantity' => 1,
      'UnitPrice' => 1000,
      'OriginalPrice' => 1000,
      'Description' => 'Descricao item teste'
    }
  }

  describe '.new' do
    subject(:item) { BraspagRest::FraudAnalyses::Item.new(braspag_response) }

    it 'initializes an item using braspag response format' do
      expect(item.name).to eq('Item teste')
      expect(item.merchant_item_id).to eq('123')
      expect(item.quantity).to eq(1)
      expect(item.unit_price).to eq(1000)
      expect(item.original_price).to eq(1000)
      expect(item.description).to eq('Descricao item teste')
    end
  end
end
