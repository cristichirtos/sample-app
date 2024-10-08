# frozen_string_literal: true

require 'vcr'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  RSpec::Matchers.define_negated_matcher :not_change, :change

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :webmock
    c.configure_rspec_metadata!
    c.default_cassette_options = { record: :once, match_requests_on: %i[method uri body] }
    c.allow_http_connections_when_no_cassette = false
  end
end
