# -*- encoding : utf-8 -*-
module BraspagRest
  class Sale < Hashie::IUTrash
    include Hashie::Extensions::Coercion

    property :request_id, from: 'RequestId'
    property :order_id, from: 'MerchantOrderId'
    property :is_splitted, from: 'IsSplitted'
    property :customer, from: 'Customer', with: ->(values) { BraspagRest::Customer.new(values) }
    property :payment, from: 'Payment', with: ->(values) { BraspagRest::Payment.new(values) }

    coerce_key :customer, BraspagRest::Customer
    coerce_key :payment, BraspagRest::Payment

    def self.find(request_id, payment_id)
      response = BraspagRest::Request.get_sale(request_id, payment_id)

      new(response.parsed_body.merge('RequestId' => request_id))
    end

    def self.find_by_order_id(request_id, order_id)
      response = BraspagRest::Request.get_sales_for_merchant_order_id(request_id, order_id)
      payments = response.parsed_body['Payments']

      Array(payments).map { |payment| BraspagRest::Sale.find(request_id, payment['PaymentId']) }
    end

    def save
      response = BraspagRest::Request.authorize(request_id, inverse_attributes)

      if response.success?
        initialize_attributes(response.parsed_body)
      else
        initialize_errors(response.parsed_body) and return false
      end

      payment.authorized?
    end

    def cancel(amount = nil)
      response = BraspagRest::Request.void(request_id, payment.id, amount)

      if response.success?
        reload
      else
        initialize_errors(response.parsed_body)
      end

      response.success?
    end

    def capture(amount = nil)
      response = BraspagRest::Request.capture(request_id, payment.id, (amount || payment.amount))

      if response.success?
        self.payment.initialize_attributes(response.parsed_body)
      else
        initialize_errors(response.parsed_body) and return false
      end

      payment.captured?
    end

    def capture_with_split(splits)
      response = BraspagRest::Request.capture_with_split(request_id, payment.id, splits)

      if response.success?
        self.payment.initialize_attributes(response.parsed_body)
      else
        initialize_errors(response.parsed_body) and return false
      end

      payment.captured?
    end

    def reload
      if !request_id.nil? && payment && !payment.id.nil?
        reloaded_reference = self.class.find(request_id, payment.id)
        self.initialize_attributes(reloaded_reference.inverse_attributes)
      end

      self
    end
  end
end
