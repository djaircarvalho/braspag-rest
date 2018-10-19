module BraspagRest
  class VoidedSplitPayment < Hashie::IUTrash
    include Hashie::Extensions::Coercion

    property :subordinate_merchant_id, from: 'SubordinateMerchantId'
    property :amount, from: 'Amount'
    property :voided_splits, from: 'VoidedSplits'

    coerce_key :voided_splits, Array[BraspagRest::VoidedSplit]

  end
end
