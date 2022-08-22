# frozen_string_literal: true

basedir = File.expand_path('../lib', __FILE__)
libraries =
  [
    'redmine_journal_notes_history/journal_patch',
    'redmine_journal_notes_history/listener',
    'redmine_journal_notes_history/user_patch',
    'redmine_journal_notes_history/utils',
    'redmine_journal_notes_history/view_listener',
  ]

libraries.each do |library|
  require_dependency File.expand_path(library, basedir)
end

Redmine::Plugin.register :redmine_journal_notes_history do
  name 'Redmine Journal Notes History plugin'
  author '9506hqwy'
  description 'This is a journal notes history plugin for Redmine'
  version '0.2.0'
  url 'https://github.com/9506hqwy/redmine_journal_notes_history'
  author_url 'https://github.com/9506hqwy'

  activity_provider :issues, class_name: 'JournalNotesHistory', default: false
end
