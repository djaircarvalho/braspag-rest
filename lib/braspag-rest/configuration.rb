# -*- encoding : utf-8 -*-
require 'singleton'
require 'yaml'

module BraspagRest
  class Configuration
    attr_accessor :environment, :logger, :config_file_path

    def config_file_path
      @config_file_path || 'config/braspag-rest.yml'
    end

    def environment
      @environment || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || raise('You must set the environment!')
    end

    def log_enabled?
      config['log_enable'] && logger
    end

    def url
      config['url']
    end

    def query_url
      config['query_url']
    end

    def split_url
      config['split_url']
    end

    def oauth2_url
      config['oauth2_url']
    end

    def client_id
      config['client_id']
    end

    def client_secret
      config['client_secret']
    end

    def request_timeout
      config.fetch('request_timeout', 60)
    end

    private

    def config
      @config ||= YAML.load(ERB.new(File.read(config_file_path)).result)[environment]
    end
  end
end
