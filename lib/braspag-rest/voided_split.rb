# -*- encoding : utf-8 -*-
module BraspagRest
  class VoidedSplit < Hashie::IUTrash
    property :merchant_id, from: 'MerchantId'
    property :voided_amount, from: 'VoidedAmount'
  end
end
