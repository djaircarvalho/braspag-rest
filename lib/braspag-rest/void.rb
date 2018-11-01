# -*- encoding : utf-8 -*-
module BraspagRest
  class Void < Hashie::IUTrash
    include Hashie::Extensions::Coercion

    property :id, from: 'Id'
    property :amount, from: 'Amount'
    property :date, from: 'Date'
    property :void_split_payments, from: 'VoidSplitPayments'

    coerce_key :void_split_payments, Array[BraspagRest::VoidSplitPayment]

  end
end
