# frozen_string_literal: true

class JournalNotesHistory < RedmineJournalNotesHistory::Utils::ModelBase
  belongs_to :journal
  belongs_to :container, polymorphic: true
  belongs_to :user

  validates :journal, presence: true
  validates :container, presence: true

  acts_as_activity_provider type: 'issues',
                            permission: :view_issues,
                            author_key: :user_id,
                            scope: RedmineJournalNotesHistory::Utils.filter_private_notes(joins(journal: {issue: :project}))

  acts_as_event title: proc { |h|
                         issue_status = ((s = h.journal.new_status) ? " (#{s})" : nil)
                         "#{h.issue.tracker} ##{h.issue.id}#{issue_status}: #{h.issue.subject} (change-#{h.journal.id} ##{h.id})"
                       },
                description: proc { |h| h.container.notes },
                author: :user,
                group: :issue,
                url: proc { |h|
                       if h.container_type == 'JournalNotesVersion'
                         { controller: :journal_notes_histories, action: :detail, journal_id: h.journal.id, history_id: h.id }
                       else
                         { controller: :issues, action: :show, id: h.issue.id, anchor: "change-#{h.journal.id}" }
                       end
                     },
                type: 'issue-note'

  delegate :issue, to: :journal

  delegate :project, to: :journal
end
