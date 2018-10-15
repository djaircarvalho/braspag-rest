# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BraspagRest::Request do
  let(:config) { YAML.load(File.read('spec/fixtures/configuration.yml'))['test'] }
  let(:logger) { double(info: nil) }

  before do
    allow_any_instance_of(BraspagRest::TokenManager).to receive(:token).and_return('Bearer eyJ0eXAiOiJ.KV1QiLCJhb.GciOiJIUzI1NiJ9')
    BraspagRest.config do |configuration|
      configuration.config_file_path = 'spec/fixtures/configuration.yml'
      configuration.environment = 'test'
      configuration.logger = logger
    end
  end

  describe '.authorize' do
    let(:sale_url) { config['url'] + '/1/sales/' }
    let(:request_id) { '30000000-0000-0000-0000-000000000001' }

    let(:headers) do
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'RequestId' => request_id,
        'Authorization' => BraspagRest::TokenManager.token,
        'Content-Length' => 0
      }
    end

    let(:params) do
      {
        'Customer' => { 'Name' => 'Maria', 'Identity' => '790.010.515-88' }
      }
    end

    context 'when is a successful response' do
      let(:gateway_response) { double(code: 200, body: '{}') }

      it 'calls sale creation with request_id and their parameters' do
        expect(RestClient::Request).to receive(:execute).with(
          method: :post,
          url: sale_url,
          payload: params.to_json,
          headers: headers,
          timeout: config['request_timeout']
        )
        described_class.authorize(request_id, params)
      end

      it 'returns a braspag successful response' do
        allow(RestClient::Request).to receive(:execute).and_return(gateway_response)

        response = described_class.authorize(request_id, params)
        expect(response).to be_success
        expect(response.parsed_body).to eq({})
      end
    end

    context 'when is a failure by invalid params' do
      let(:gateway_response) { double(code: 400, body: '{}') }

      it 'returns a braspag unsuccessful response and log it as a warning' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::ExceptionWithResponse, gateway_response)
        expect(logger).to receive(:warn).with('[BraspagRest][Error] message: RestClient::ExceptionWithResponse, status: 400, body: "{}"')

        response = described_class.authorize(request_id, params)
        expect(response).not_to be_success
        expect(response.parsed_body).to eq({})
      end
    end

    context 'when is a failure by unexpected exception' do
      let(:gateway_response) { double(code: 500, body: '{}') }

      it 'raises the exception and log it as an error' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::Exception, gateway_response)
        expect(logger).to receive(:error).with('[BraspagRest][Error] message: RestClient::Exception, status: 500, body: "{}"')

        expect { described_class.authorize(request_id, params) }.to raise_error(RestClient::Exception)
      end
    end

    context 'when a timeout occurs' do
      it 'raises the exception and log it as an error' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::RequestTimeout)
        expect(logger).to receive(:error).with('[BraspagRest][Timeout] message: Request Timeout')

        expect { described_class.authorize(request_id, params) }.to raise_error(RestClient::RequestTimeout)
      end
    end
  end

  describe '.void' do
    let(:payment_id) { '123456' }
    let(:request_id) { '30000000-0000-0000-0000-000000000001' }
    let(:amount) { nil }

    let(:headers) do
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'RequestId' => request_id,
        'Authorization' => BraspagRest::TokenManager.token,
        'Content-Length' => 0
      }
    end

    context 'when no amount is given' do
      let(:void_url) { config['url'] + '/1/sales/' + payment_id + '/void' }

      it 'does not specify an amount to be voided' do
        expect(RestClient::Request).to receive(:execute).with(
          method: :put,
          url: void_url,
          headers: headers,
          timeout: config['request_timeout']
        )
        described_class.void(request_id, payment_id, amount)
      end
    end

    context 'when an amount is given' do
      let(:void_url) { config['url'] + '/1/sales/' + payment_id + "/void?amount=#{amount}" }
      let(:amount) { 100 }

      it 'includes specific amount to void in request' do
        expect(RestClient::Request).to receive(:execute).with(
          method: :put,
          url: void_url,
          headers: headers,
          timeout: config['request_timeout']
        )
        described_class.void(request_id, payment_id, amount)
      end
    end

    context 'when is a successful response' do
      let(:gateway_response) { double(code: 200, body: '{}') }

      it 'returns a braspag successful response' do
        allow(RestClient::Request).to receive(:execute).and_return(gateway_response)

        response = described_class.void(request_id, payment_id, amount)
        expect(response).to be_success
        expect(response.parsed_body).to eq({})
      end
    end

    context 'when is a failure by invalid params' do
      let(:gateway_response) { double(code: 400, body: '{}') }

      it 'returns a braspag unsuccessful response and log it as a warning' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::ExceptionWithResponse, gateway_response)
        expect(logger).to receive(:warn).with('[BraspagRest][Error] message: RestClient::ExceptionWithResponse, status: 400, body: "{}"')

        response = described_class.void(request_id, payment_id, amount)
        expect(response).not_to be_success
        expect(response.parsed_body).to eq({})
      end
    end

    context 'when is a failure by unexpected exception' do
      let(:gateway_response) { double(code: 500, body: '{}') }

      it 'raises the exception and log it as an error' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::Exception, gateway_response)
        expect(logger).to receive(:error).with('[BraspagRest][Error] message: RestClient::Exception, status: 500, body: "{}"')

        expect { described_class.void(request_id, payment_id, amount) }.to raise_error(RestClient::Exception)
      end
    end

    context 'when a timeout occurs' do
      it 'raises the exception and log it as an error' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::RequestTimeout)
        expect(logger).to receive(:error).with('[BraspagRest][Timeout] message: Request Timeout')

        expect { described_class.void(request_id, payment_id, amount) }.to raise_error(RestClient::RequestTimeout)
      end
    end
  end

  describe '.get_sale' do
    let(:payment_id) { '123456' }
    let(:search_url) { config['query_url'] + '/1/sales/' + payment_id }
    let(:request_id) { '30000000-0000-0000-0000-000000000001' }

    let(:headers) do
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'RequestId' => request_id,
        'Authorization' => BraspagRest::TokenManager.token,
        'Content-Length' => 0
      }
    end

    context 'when is a successful response' do
      let(:gateway_response) { double(code: 200, body: '{}') }

      it 'calls sale void with request_id and amount' do
        expect(RestClient::Request).to receive(:execute).with(
          method: :get,
          url: search_url,
          headers: headers,
          timeout: config['request_timeout']
        )
        described_class.get_sale(request_id, payment_id)
      end

      it 'returns a braspag successful response' do
        allow(RestClient::Request).to receive(:execute).and_return(gateway_response)

        response = described_class.get_sale(request_id, payment_id)
        expect(response).to be_success
        expect(response.parsed_body).to eq({})
      end
    end

    context 'when is a failure by resource not found exception' do
      let(:gateway_response) { double(code: 404, body: '{}') }

      it 'raises the exception and log it as an error' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::ResourceNotFound)
        expect(logger).to receive(:error).with('[BraspagRest][Error] message: Resource Not Found, status: , body: nil')

        expect { described_class.get_sale(request_id, payment_id) }.to raise_error(RestClient::ResourceNotFound)
      end
    end

    context 'when a timeout occurs' do
      it 'raises the exception and log it as an error' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::RequestTimeout)
        expect(logger).to receive(:error).with('[BraspagRest][Timeout] message: Request Timeout')

        expect { described_class.get_sale(request_id, payment_id) }.to raise_error(RestClient::RequestTimeout)
      end
    end
  end

  describe '#split' do
    let(:payment_id) { '123456' }
    let(:split_url) { config['split_url'] + payment_id + '/split' }
    let(:request_id) { '30000000-0000-0000-0000-000000000001' }

    let(:headers) do
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'Authorization' => BraspagRest::TokenManager.token,
        'Content-Length' => 0
      }
    end

    let(:split1) do
      BraspagRest::SplitPayment.new(
        subordinate_merchant_id: 'a4133798-9fac-4592-b040-d62d8239bd97',
        amount:  6000,
        fares:  {
          mdr:  5,
          fee:  30
        }
      )
    end

    let(:split2) do
      BraspagRest::SplitPayment.new(
        subordinate_merchant_id: '20943d1a-153f-42b6-93b8-07b9db000651',
        amount: 4000,
        fares: {
          mdr: 4,
          fee: 15
        }
      )
    end

    context 'when is a successful response' do
      let(:gateway_response) { double(code: 200, body: '{}') }

      it 'calls sale split with request_id' do
        expect(RestClient::Request).to receive(:execute).with(
          method: :put,
          url: split_url,
          payload: [split1.inverse_attributes, split2.inverse_attributes].to_json,
          headers: headers,
          timeout: config['request_timeout']
        )
        described_class.split(payment_id, [split1, split2])
      end

      it 'returns a braspag successful response' do
        allow(RestClient::Request).to receive(:execute).and_return(gateway_response)

        response = described_class.split(payment_id, [split1, split2])
        expect(response).to be_success
        expect(response.parsed_body).to eq({})
      end
    end

    context 'when is a failure by resource not found exception' do
      let(:gateway_response) { double(code: 404, body: '{}') }

      it 'raises the exception and log it as an error' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::ResourceNotFound)
        expect(logger).to receive(:error).with('[BraspagRest][Error] message: Resource Not Found, status: , body: nil')

        expect { described_class.split(payment_id, [split1, split2]) }.to raise_error(RestClient::ResourceNotFound)
      end
    end

    context 'when a timeout occurs' do
      it 'raises the exception and log it as an error' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::RequestTimeout)
        expect(logger).to receive(:error).with('[BraspagRest][Timeout] message: Request Timeout')

        expect { described_class.split(payment_id, [split1, split2]) }.to raise_error(RestClient::RequestTimeout)
      end
    end
  end

  describe '.get_sales_for_merchant_order_id' do
    let(:logger) { double(info: nil) }
    let(:request_id) { SecureRandom.uuid }
    let(:transaction_id) { '1234567890' }

    before do
      allow(BraspagRest.config).to receive(:logger).and_return logger
      allow(RestClient::Request).to receive(:execute)
    end

    it 'logs the requested url' do
      expect(logger).to receive(:info).with("[BraspagRest][GetSale] endpoint: https://apiquerysandbox.cieloecommerce.cielo.com.br/1/sales/?merchantOrderId=#{transaction_id}")
      BraspagRest::Request.get_sales_for_merchant_order_id(request_id, transaction_id)
    end

    it 'request with the correct parameters' do
      expect(RestClient::Request).to receive(:execute).with(
        method: :get,
        url: "https://apiquerysandbox.cieloecommerce.cielo.com.br/1/sales/?merchantOrderId=#{transaction_id}",
        headers: described_class.send(:default_headers).merge('RequestId' => request_id),
        timeout: BraspagRest.config.request_timeout
      )
      BraspagRest::Request.get_sales_for_merchant_order_id(request_id, transaction_id)
    end
  end

  describe '.capture' do
    let(:payment_id) { '123456' }
    let(:capture_url) { config['url'] + '/1/sales/' + payment_id + '/capture' }
    let(:request_id) { '30000000-0000-0000-0000-000000000001' }
    let(:amount) { 100 }

    let(:headers) do
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'RequestId' => request_id,
        'Authorization' => BraspagRest::TokenManager.token,
        'Content-Length' => 0
      }
    end

    context 'when is a successful response' do
      let(:gateway_response) { double(code: 200, body: '{}') }

      it 'calls sale capture with request_id and amount' do
        expect(RestClient::Request).to receive(:execute).with(
          method: :put,
          url: capture_url,
          payload: { Amount: amount }.to_json,
          headers: headers,
          timeout: config['request_timeout']
        )
        described_class.capture(request_id, payment_id, amount)
      end

      it 'returns a braspag successful response' do
        allow(RestClient::Request).to receive(:execute).and_return(gateway_response)

        response = described_class.capture(request_id, payment_id, amount)
        expect(response).to be_success
        expect(response.parsed_body).to eq({})
      end
    end

    context 'when is a failure by invalid params' do
      let(:gateway_response) { double(code: 400, body: '{}') }

      it 'returns a braspag unsuccessful response and log it as a warning' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::ExceptionWithResponse, gateway_response)
        expect(logger).to receive(:warn).with('[BraspagRest][Error] message: RestClient::ExceptionWithResponse, status: 400, body: "{}"')

        response = described_class.capture(request_id, payment_id, amount)
        expect(response).not_to be_success
        expect(response.parsed_body).to eq({})
      end
    end

    context 'when is a failure by unexpected exception' do
      let(:gateway_response) { double(code: 500, body: '{}') }

      it 'raises the exception and log it as an error' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::Exception, gateway_response)
        expect(logger).to receive(:error).with('[BraspagRest][Error] message: RestClient::Exception, status: 500, body: "{}"')

        expect { described_class.capture(request_id, payment_id, amount) }.to raise_error(RestClient::Exception)
      end
    end

    context 'when a timeout occurs' do
      it 'raises the exception and log it as an error' do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::RequestTimeout)
        expect(logger).to receive(:error).with('[BraspagRest][Timeout] message: Request Timeout')

        expect { described_class.capture(request_id, payment_id, amount) }.to raise_error(RestClient::RequestTimeout)
      end
    end
  end
end
