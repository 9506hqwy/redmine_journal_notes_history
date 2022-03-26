# frozen_string_literal: true

module RedmineJournalNotesHistory
  class Listener < Redmine::Hook::Listener
    def controller_journals_edit_post(context)
      journal = context[:journal]
      return if journal.destroyed?

      version = JournalNotesVersion.new
      version.journal = journal
      version.notes = previous_value(journal, 'notes')
      version.private_notes = previous_value(journal, 'private_notes')
      version.save

      history = journal.note_history
      if history
        history.container = version
      else
        history = JournalNotesHistory.new
        history.journal = journal
        history.container = version
        history.user = journal.user
      end
      history.save

      history = JournalNotesHistory.new
      history.journal = journal
      history.container = journal
      history.user = User.current
      history.save
    end

    private

    def previous_value(target, name)
      value = target.previous_changes[name]&.first
      value = target.send(name) if value.nil?
      value
    end
  end
end
