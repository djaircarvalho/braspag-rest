module BraspagRest
  class SplitPayment < Hashie::IUTrash
    property :subordinate_merchant_id, from: 'SubordinateMerchantId'
    property :amount, from: 'Amount'
    property :fares, from: 'Fares', with: ->(values) { BraspagRest::Fare.new(values) }
  end
end
