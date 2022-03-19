# frozen_string_literal: true

module RedmineJournalNotesHistory
  class ViewListener < Redmine::Hook::ViewListener
    render_on :view_issues_history_journal_bottom, partial: 'journal_notes_histories/journal_bottom'
  end
end
