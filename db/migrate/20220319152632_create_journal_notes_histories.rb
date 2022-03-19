# frozen_string_literal: true

class CreateJournalNotesHistories < RedmineJournalNotesHistory::Utils::Migration
  def change
    create_table :journal_notes_histories do |t|
      t.belongs_to :journal, null: false, foreign_key: true
      t.references :container, null: false, polymorphic: true
      t.belongs_to :user, foreign_key: true
      t.timestamp :created_on, null: false
    end
  end
end
