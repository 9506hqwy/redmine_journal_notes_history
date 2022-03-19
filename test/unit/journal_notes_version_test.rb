# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class JournalNotesVersionTest < ActiveSupport::TestCase
  fixtures :journals,
           :users,
           :journal_notes_histories,
           :journal_notes_versions

  def test_create
    j = journals(:journals_002)

    v = JournalNotesVersion.new
    v.journal = j
    v.notes = 'a'
    v.private_notes = false
    v.save!

    v.reload
    assert_equal j.id, v.journal_id
    assert_equal 'a', v.notes
    assert_not v.private_notes
  end

  def test_update
    j = journals(:journals_002)

    v = journal_notes_versions(:journal_notes_versions_001)
    v.journal = j
    v.notes = 'b'
    v.private_notes = true
    v.save!

    v.reload
    assert_equal j.id, v.journal_id
    assert_equal 'b', v.notes
    assert v.private_notes
  end

  def test_destory
    v = journal_notes_versions(:journal_notes_versions_001)
    id = v.note_history.id
    assert_not_equal 0, id

    v.destroy!

    begin
      JournalNotesHistory.find(id)
      assert false
    rescue ActiveRecord::RecordNotFound
      assert true
    end
  end
end
