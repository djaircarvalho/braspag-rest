# -*- encoding : utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'simplecov-console'
#SimpleCov.formatter = SimpleCov::Formatter::Console
require 'braspag-rest'
require 'json'
