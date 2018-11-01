module BraspagRest
  class VoidSplitPayment < Hashie::IUTrash
    include Hashie::Extensions::Coercion

    property :subordinate_merchant_id, from: 'SubordinateMerchantId'
    property :voided_amount, from: 'VoidedAmount'
    property :voided_splits, from: 'VoidedSplits'

    coerce_key :voided_splits, Array[BraspagRest::VoidedSplit]

  end
end
