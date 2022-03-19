# frozen_string_literal: true

# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
ActiveRecord::FixtureSet.create_fixtures(
  File.expand_path('../fixtures', __FILE__),
  [
    'journal_notes_histories',
    'journal_notes_versions',
  ]
)
