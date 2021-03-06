module BraspagRest
  module FraudAnalyses
    class Item < Hashie::IUTrash
      include Hashie::Extensions::Coercion

      property :gift_category, from: 'GiftCategory'
      property :host_hedge, from: 'HostHedge'
      property :non_sensical_hedge, from: 'NonSensicalHedge'
      property :obscenities_hedge, from: 'ObscenitiesHedge'
      property :phone_hedge, from: 'PhoneHedge'
      property :name, from: 'Name'
      property :quantity, from: 'Quantity'
      property :sku, from: 'Sku'
      property :unit_price, from: 'UnitPrice'
      property :risk, from: 'Risk'
      property :time_hedge, from: 'TimeHedge'
      property :type, from: 'Type'
      property :velocity_hedge, from: 'VelocityHedge'

      property :merchant_item_id, from: 'MerchantItemId'
      property :original_price, from: 'OriginalPrice'
      property :description, from: 'Description'

      property :weight, from: 'Weight'
      property :cart_type, from: 'CartType'
    end
  end
end
