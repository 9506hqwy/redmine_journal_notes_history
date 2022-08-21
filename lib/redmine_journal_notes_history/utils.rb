# frozen_string_literal: true

module RedmineJournalNotesHistory
  module Utils
    if ActiveRecord::VERSION::MAJOR >= 5
      Migration = ActiveRecord::Migration[4.2]
    else
      Migration = ActiveRecord::Migration
    end

    def self.filter_private_notes(query)
      # `.left_joins(...)` in Rails5 or later.
      query
        .joins("LEFT OUTER JOIN journals AS t0 ON t0.id = journal_notes_histories.container_id AND journal_notes_histories.container_type = 'Journal'")
        .joins("LEFT OUTER JOIN journal_notes_versions  AS t1 ON t1.id = journal_notes_histories.container_id AND journal_notes_histories.container_type = 'JournalNotesVersion'")
        .where('t0.private_notes = ? OR t1.private_notes = ?', false, false)
    end
  end
end
