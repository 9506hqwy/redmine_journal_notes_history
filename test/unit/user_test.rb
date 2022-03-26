# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class UserTest < ActiveSupport::TestCase
  fixtures :journals,
           :users,
           :journal_notes_histories,
           :journal_notes_versions

  def test_destroy
    h = journal_notes_histories(:journal_notes_histories_003)
    u = users(:users_002)
    assert_equal u.id, h.user_id

    u.destroy!

    h.reload
    assert_equal User.anonymous.id, h.user_id
  end
end
