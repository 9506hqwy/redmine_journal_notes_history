# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class JournalNotesHistoryTest < ActiveSupport::TestCase
  fixtures :journals,
           :users,
           :journal_notes_histories,
           :journal_notes_versions

  def test_create_journal
    j = journals(:journals_002)
    u = users(:users_001)

    h = JournalNotesHistory.new
    h.journal = j
    h.container = j
    h.user = u
    h.save!

    h.reload
    assert_equal j.id, h.journal_id
    assert_equal j.id, h.container_id
    assert_equal j.class.name, h.container_type
    assert_equal u.id, h.user_id
    assert_not_nil h.created_on
  end

  def test_create_journal_version
    j = journals(:journals_002)
    v = journal_notes_versions(:journal_notes_versions_002)
    u = users(:users_001)

    h = JournalNotesHistory.new
    h.journal = j
    h.container = v
    h.user = u
    h.save!

    h.reload
    assert_equal j.id, h.journal_id
    assert_equal v.id, h.container_id
    assert_equal v.class.name, h.container_type
    assert_equal u.id, h.user_id
    assert_not_nil h.created_on
  end

  def test_update
    j = journals(:journals_002)
    u = users(:users_001)

    h = journal_notes_histories(:journal_notes_histories_002)
    d = h.created_on
    h.container = j
    h.user = u
    h.save!

    h.reload
    assert_equal j.id, h.container_id
    assert_equal j.class.name, h.container_type
    assert_equal u.id, h.user_id
    assert_equal d, h.created_on
  end
end
