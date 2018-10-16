module BraspagRest
  class SplitPayment < Hashie::IUTrash
    include Hashie::Extensions::Coercion
    
    property :subordinate_merchant_id, from: 'SubordinateMerchantId'
    property :amount, from: 'Amount'
    property :fares, from: 'Fares'
    property :splits, from: 'Splits'

    coerce_key :splits, Array[BraspagRest::Split]
    coerce_key :fares, BraspagRest::Fare
  end
end
