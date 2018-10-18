module BraspagRest
  class Customer < Hashie::IUTrash
    property :name, from: 'Name'
    property :identity, from: 'Identity'
    property :identity_type, from: 'IdentityType'
    property :address, from: 'Address', with: ->(values) { BraspagRest::Address.new(values) }
    property :delivery_address, from: 'DeliveryAddress', with: ->(values) { BraspagRest::Address.new(values) }
    property :billing_address, from: 'BillingAddress', with: ->(values) { BraspagRest::Address.new(values) }
  end
end
