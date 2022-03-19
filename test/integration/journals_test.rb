# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class JournalsTest < Redmine::IntegrationTest
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

  def test_update_new
    j = journals(:journals_002)
    history = j.note_history
    assert_nil history
    history_count = j.note_histories.count
    version_count = j.note_versions.count

    log_user('admin', 'admin')

    put(
      "/journals/#{j.id}",
      params: {
        journal: {
          notes: 'a',
            private_notes: false,
        },
      })

    assert_redirected_to "/issues/#{j.issue.id}"

    j.reload
    assert_not_nil j.note_history
    assert_equal history_count + 2, j.note_histories.count
    assert_equal version_count + 1, j.note_versions.count
    assert_equal 1, j.note_history.user_id
    assert_equal 'a', j.note_history.container.notes
    assert_not j.note_history.container.private_notes

    put(
      "/journals/#{j.id}",
      params: {
        journal: {
          notes: 'b',
            private_notes: true,
        },
      })

    assert_redirected_to "/issues/#{j.issue.id}"

    j.reload
    assert_not_nil j.note_history
    assert_equal history_count + 3, j.note_histories.count
    assert_equal version_count + 2, j.note_versions.count
    assert_equal 1, j.note_history.user_id
    assert_equal 'b', j.note_history.container.notes
    assert j.note_history.container.private_notes

    latest = j.note_histories.order(created_on: 'DESC').second
    assert_equal 1, latest.user_id
    assert_equal 'a', latest.container.notes
    assert_not latest.container.private_notes
  end

  def test_update_add
    j = journals(:journals_001)
    history = j.note_history
    assert_not_nil history
    history_count = j.note_histories.count
    version_count = j.note_versions.count

    log_user('admin', 'admin')

    put(
      "/journals/#{j.id}",
      params: {
        journal: {
          notes: 'a',
          private_notes: true,
        },
      })

    assert_redirected_to "/issues/#{j.issue.id}"

    j.reload
    assert_not_equal history.id, j.note_history.id
    assert_equal history_count + 1, j.note_histories.count
    assert_equal version_count + 1, j.note_versions.count
    assert_equal 1, j.note_history.user_id
    assert_equal 'a', j.note_history.container.notes
    assert j.note_history.container.private_notes
  end
end
