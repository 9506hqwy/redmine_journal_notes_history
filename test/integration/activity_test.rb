# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class ActivityTest < Redmine::IntegrationTest
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

    get('/projects/ecookbook/activity')

    assert_response :success
    assert_select 'a[href="/journals/1/note_history/detail?history_id=2"]'
  end
end
