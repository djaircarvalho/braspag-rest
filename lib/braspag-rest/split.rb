# -*- encoding : utf-8 -*-
module BraspagRest
  class Split < Hashie::IUTrash
    property :merchant_id, from: 'MerchantId'
    property :amount, from: 'Amount'
  end
end
