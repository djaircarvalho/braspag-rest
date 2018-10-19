# -*- encoding : utf-8 -*-
require 'hashie/extensions/dash/property_translation'

module Hashie
  class IUTrash < Hashie::IUDash
    include Hashie::Extensions::Dash::PropertyTranslation

    attr_reader :errors

    def inverse_attributes
      self.class.translations.each_with_object({}) do |(from, property), attributes|
        value = nested_inverse(self.send(property))

        unless value.nil?
          attributes[from] = value
        end
      end
    end

    private

    def nested_inverse(value)
      if [[].class, Array, Set].include?(value.class)
        value.map { |item| attributes_for(item) }
      else
        attributes_for(value)
      end
    end

    def attributes_for(value)
      value.respond_to?(:inverse_attributes) ? value.inverse_attributes : value
    end

    def initialize_errors(errors)
      if errors.is_a? [].class
        @errors = errors.map { |error| { code: error['Code'], message: error['Message'] } }
      else
        @errors = errors['Errors'].map { |error| { code: error['Code'], message: error['Message'] } }
      end
    end
  end
end
