# frozen_string_literal: true

require_dependency 'journal_notes_history/journal_patch'
require_dependency 'journal_notes_history/listener'
require_dependency 'journal_notes_history/utils'
require_dependency 'journal_notes_history/view_listener'

Redmine::Plugin.register :redmine_journal_notes_history do
  name 'Redmine Journal Notes History plugin'
  author '9506hqwy'
  description 'This is a journal notes history plugin for Redmine'
  version '0.1.0'
  url 'https://github.com/9506hqwy/redmine_journal_notes_history'
  author_url 'https://github.com/9506hqwy'
end
