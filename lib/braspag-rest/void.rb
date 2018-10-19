module BraspagRest
  class Void < Hashie::IUTrash
    include Hashie::Extensions::Coercion

    property :id, from: 'Id'
    property :amount, from: 'Amount'
    property :date, from: 'Date'
    property :voided_split_payments, from: 'VoidedSplitPayments'

    coerce_key :voided_split_payments, Array[BraspagRest::VoidedSplitPayment]

  end
end
