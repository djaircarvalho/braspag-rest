# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BraspagRest::Configuration do
  context 'when there is custom configuration file and environment name' do
    subject(:configuration) { BraspagRest::Configuration.new }

    it 'configures the gem using values from configuration file' do
      configuration.config_file_path = 'spec/fixtures/configuration.yml'
      configuration.environment = 'test'

      expect(configuration.config_file_path).to eq('spec/fixtures/configuration.yml')
      expect(configuration.environment).to eq('test')
      expect(configuration.url).to eq('https://apisandbox.cieloecommerce.cielo.com.br')
      expect(configuration.query_url).to eq('https://apiquerysandbox.cieloecommerce.cielo.com.br')
      expect(configuration.oauth2_url).to eq('https://authsandbox.braspag.com.br/oauth2/token')
      expect(configuration.client_id).to eq('abf26594-b758-4a69-841d-e254285f7068')
      expect(configuration.client_secret).to eq('i8xPgT2sdPGhAIy/RITggrRspLDbPleMOri9UXZ6Mr0=')
    end
  end

  context 'default configuration' do
    subject(:configuration) { BraspagRest::Configuration.new }

    it 'returns a instance of braspag configuration with default config file path' do
      expect(configuration.config_file_path).to eq('config/braspag-rest.yml')
    end

    it 'sets RACK_ENV variable value as environment if is filled' do
      ENV['RACK_ENV'] = 'production'
      ENV['RAILS_ENV'] = nil
      expect(configuration.environment).to eq('production')
    end

    it 'sets RAILS_ENV variable value as environment if is filled' do
      ENV['RAILS_ENV'] = 'qa'
      ENV['RACK_ENV'] = nil
      expect(configuration.environment).to eq('qa')
    end
  end

  context 'when the config file has ERB blocks' do
    subject(:configuration) { BraspagRest::Configuration.new }

    it 'processes the ERB code before parsing the configuration' do
      configuration.config_file_path = 'spec/fixtures/configuration.yml'
      configuration.environment = 'production'

      ENV['BRASPAG_CLIENT_SECRET'] = 'BRASPAG_CLIENT_SECRET_SET_THROUGH_ENV'
      expect(configuration.client_secret).to eq('BRASPAG_CLIENT_SECRET_SET_THROUGH_ENV')
    end
  end
end
