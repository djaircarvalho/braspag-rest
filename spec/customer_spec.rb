require 'spec_helper'

describe BraspagRest::Customer do
  let(:braspag_response) {
    {
      'Name' => 'Comprador Teste',
      'Identity' => '790.010.515-88',
      'IdentityType' => 'CPF',
      'Email' => 'teste@teste.com.br',
      'IpAddress' => '200.200.0.0',
      'Address' => {
        'Street' => 'Alameda Xingu',
        'Number' => '512',
        'Complement' => '27 andar',
        'ZipCode' => '12345987',
        'City' => 'São Paulo',
        'State' => 'SP',
        'Country' => 'BRA',
        'District' => 'Alphaville'
      },
      'DeliveryAddress' => {
        'Street' => 'Alameda Xingu',
        'Number' => '512',
        'Complement' => '27 andar',
        'ZipCode' => '12345987',
        'City' => 'São Paulo',
        'State' => 'SP',
        'Country' => 'BRA',
        'District' => 'Alphaville'
      },
      'BillingAddress' => {
        'Street' => 'Alameda Xingu',
        'Number' => '512',
        'Complement' => '27 andar',
        'ZipCode' => '12345987',
        'City' => 'São Paulo',
        'State' => 'SP',
        'Country' => 'BRA',
        'District' => 'Alphaville'
      }
    }
  }

  describe '.new' do
    subject(:customer) { BraspagRest::Customer.new(braspag_response) }

    it 'initializes a customer using braspag response format' do
      expect(customer.name).to eq('Comprador Teste')
      expect(customer.identity).to eq('790.010.515-88')
      expect(customer.identity_type).to eq('CPF')
      expect(customer.email).to eq('teste@teste.com.br')
      expect(customer.ip_address).to eq('200.200.0.0')
      expect(customer.address).to be_an_instance_of(BraspagRest::Address)
      expect(customer.delivery_address).to be_an_instance_of(BraspagRest::Address)
      expect(customer.billing_address).to be_an_instance_of(BraspagRest::Address)
    end
  end
end
