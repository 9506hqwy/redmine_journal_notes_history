# frozen_string_literal: true

RedmineApp::Application.routes.draw do
  resources :journals do
    get '/note_history', to: 'journal_notes_histories#show', format: false
    get '/note_history/detail', to: 'journal_notes_histories#detail', format: false
    get '/note_history/diff', to: 'journal_notes_histories#diff', format: false
  end
end
