module BraspagRest
  class SplitPayment < Hashie::IUTrash
    property :subordinate_merchant_id, from: 'SubordinateMerchantId'
    property :amount, from: 'Amount'
  end
end
