require 'spec_helper'

describe BraspagRest::FraudAnalyses::Browser do
  let(:braspag_response) {
    {
      'IpAddress' => '200.200.0.0',
      'BrowserFingerPrint' => 'browser_finger_print_token'
    }
  }

  describe '.new' do
    subject(:browser) { BraspagRest::FraudAnalyses::Browser.new(braspag_response) }

    it 'initializes a browser using braspag response format' do
      expect(browser.ip_address).to eq('200.200.0.0')
      expect(browser.browser_finger_print).to eq('browser_finger_print_token')
    end
  end
end
