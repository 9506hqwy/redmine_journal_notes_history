# frozen_string_literal: true

module RedmineJournalNotesHistory
  module Utils
    if ActiveRecord::VERSION::MAJOR >= 5
      Migration = ActiveRecord::Migration[4.2]
    else
      Migration = ActiveRecord::Migration
    end

    def self.filter_private_notes(query)
      join_container(query)
        .where('journals.private_notes = ? OR journal_notes_versions.private_notes = ?', false, false)
    end

    def self.join_container(query)
      # `.left_joins(...)` in Rails5 or later.
      query
        .joins("LEFT OUTER JOIN journals ON journals.id = journal_notes_histories.container_id AND journal_notes_histories.container_type = 'Journal'")
        .joins("LEFT OUTER JOIN journal_notes_versions ON journal_notes_versions.id = journal_notes_histories.container_id AND journal_notes_histories.container_type = 'JournalNotesVersion'")
    end
  end
end
