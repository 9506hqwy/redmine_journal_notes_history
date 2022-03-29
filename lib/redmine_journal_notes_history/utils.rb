# frozen_string_literal: true

module RedmineJournalNotesHistory
  module Utils
    if ActiveRecord::VERSION::MAJOR >= 5
      Migration = ActiveRecord::Migration[4.2]
    else
      Migration = ActiveRecord::Migration
    end
  end
end
