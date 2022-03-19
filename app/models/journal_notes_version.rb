# frozen_string_literal: true

class JournalNotesVersion < ActiveRecord::Base
  belongs_to :journal
  has_one(:note_history, class_name: :JournalNotesHistory, as: :container, dependent: :destroy)

  validates :journal, presence: true
  validates :notes, presence: true

  def editable_by?(user)
    # for `render_notes` method in Redmine3.
    false
  end
end
