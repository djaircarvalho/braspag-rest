require 'spec_helper'

describe BraspagRest::Fare do
  let(:braspag_response) {
    {
      'Mdr' => 2,
      'Fee' => 30
    }
  }

  describe '.new' do
    subject(:fare) { BraspagRest::Fare.new(braspag_response) }

    it 'initializes an fare using braspag response format' do
      expect(fare.mdr).to eq(2)
      expect(fare.fee).to eq(30)
    end
  end
end
