# frozen_string_literal: true

require 'diff/lcs'
require 'diff/lcs/hunk'

module JournalNotesHistoriesHelper
  include JournalsHelper

  def deny_private_notes?
    !User.current.allowed_to?(:view_private_notes, @project)
  end

  def diff_journal_notes(from, to)
    from_notes = from.notes.split("\n").map(&:chomp)
    to_notes = to.notes.split("\n").map(&:chomp)

    hunks = Diff::LCS.diff(from_notes, to_notes).map do |b|
      Diff::LCS::Hunk.new(from_notes, to_notes, b, 3, 0)
    end

    merge_hunks(hunks).reduce('') { |result, hunk| result + "\n" + hunk.diff(:unified) }
  end

  def journal_breadcrumb(journal)
    breadcrumb(
      link_to("#{journal.issue.tracker.name}  ##{journal.issue.id}",
              {
                controller: :issues,
                action: :show,
                id: journal.issue.id,
              }),
      link_to("change-#{journal.id}",
              {
                controller: :issues,
                action: :show,
                anchor: "change-#{journal.id}",
                id: journal.issue.id,
              })
    )
  end

  def link_to_notes_history(id, page)
    link_to(id,
            {
              controller: :journal_notes_histories,
              action: :detail,
              history_id: id,
              page: page,
            })
  end

  def merge_hunks(hunks)
    ret = []

    hunks.each_with_index do |hunk, idx|
      if idx != 0
        if hunk.overlaps?(hunks[idx -1])
          hunk.merge(hunks[idx - 1])
        else
          ret << hunks[idx - 1]
        end
      end

      if (idx + 1) == hunks.length
        ret << hunk
      end
    end

    ret
  end

  def title_link_to_journal_notes_history(journal, from_id, to_id, page)
    [
      l(:label_history),
      {
        action: :show,
        journal_id: journal.id,
        from_id: from_id,
        to_id: to_id,
        page: page,
      },
    ]
  end
end
