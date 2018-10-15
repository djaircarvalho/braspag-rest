# -*- encoding : utf-8 -*-
module BraspagRest
  class SplitPayment < Hashie::IUTrash
    include Hashie::Extensions::Coercion
    
    property :subordinate_merchant_id, from: 'SubordinateMerchantId'
    property :amount, from: 'Amount'
    property :fares, from: 'Fares', with: ->(values) { BraspagRest::Fare.new(values) }
    property :splits, from: 'Splits'

    coerce_key :splits, Array[BraspagRest::Split]
  end
end
