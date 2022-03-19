# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class IssuesTest < Redmine::IntegrationTest
  include Redmine::I18n

  fixtures :enabled_modules,
           :enumerations,
           :issue_statuses,
           :issues,
           :journal_details,
           :journals,
           :member_roles,
           :members,
           :projects,
           :projects_trackers,
           :roles,
           :trackers,
           :users,
           :versions,
           :journal_notes_histories,
           :journal_notes_versions

  def test_show
    log_user('admin', 'admin')

    get('/issues/1')

    assert_response :success
    assert_select 'div#change-history-1'
  end
end
