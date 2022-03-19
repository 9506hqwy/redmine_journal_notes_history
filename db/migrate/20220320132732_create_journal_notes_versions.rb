# frozen_string_literal: true

class CreateJournalNotesVersions < RedmineJournalNotesHistory::Utils::Migration
  def change
    create_table :journal_notes_versions do |t|
      t.belongs_to :journal, null: false, foreign_key: true
      t.text :notes, null: false
      t.boolean :private_notes, null: false
    end
  end
end
