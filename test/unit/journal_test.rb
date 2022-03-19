# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class JournalTest < ActiveSupport::TestCase
  fixtures :journals,
           :users,
           :journal_notes_histories,
           :journal_notes_versions

  def test_destory_note_history
    j = journals(:journals_001)
    id = j.note_history.id
    assert_not_equal 0, id

    j.destroy!

    begin
      JournalNotesHistory.find(id)
      assert false
    rescue ActiveRecord::RecordNotFound
      assert true
    end
  end

  def test_destory_note_histories
    j = journals(:journals_001)
    id = j.note_histories.first.id
    assert_not_equal 0, id

    j.destroy!

    begin
      JournalNotesHistory.find(id)
      assert false
    rescue ActiveRecord::RecordNotFound
      assert true
    end
  end

  def test_destory_note_versions
    j = journals(:journals_001)
    id = j.note_versions.first.id
    assert_not_equal 0, id

    j.destroy!

    begin
      JournalNotesVersion.find(id)
      assert false
    rescue ActiveRecord::RecordNotFound
      assert true
    end
  end
end
