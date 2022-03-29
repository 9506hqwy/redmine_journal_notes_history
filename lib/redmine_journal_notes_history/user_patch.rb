# frozen_string_literal: true

module RedmineJournalNotesHistory
  module UserPatch
    def self.prepended(base)
      base.class_eval do
        before_destroy :journal_notes_history_remove_reference
      end
    end

    def journal_notes_history_remove_reference
      return if id.nil?

      substitute = User.anonymous
      JournalNotesHistory.where(user_id: id).update_all(user_id: substitute.id)
    end
  end
end

User.prepend RedmineJournalNotesHistory::UserPatch
