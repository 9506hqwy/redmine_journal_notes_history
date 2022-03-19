# frozen_string_literal: true

class JournalNotesHistory < ActiveRecord::Base
  belongs_to :journal
  belongs_to :container, polymorphic: true
  belongs_to :user

  validates :journal, presence: true
  validates :container, presence: true
end
