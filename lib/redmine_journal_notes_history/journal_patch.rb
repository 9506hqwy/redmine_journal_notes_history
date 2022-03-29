# frozen_string_literal: true

module RedmineJournalNotesHistory
  module JournalPatch
    def self.prepended(base)
      base.class_eval do
        has_one(:note_history, class_name: :JournalNotesHistory, as: :container, dependent: :destroy)
        has_many(:note_histories, class_name: :JournalNotesHistory, dependent: :destroy)
        has_many(:note_versions, class_name: :JournalNotesVersion, dependent: :destroy)
      end
    end
  end
end

Journal.prepend RedmineJournalNotesHistory::JournalPatch
