# frozen_string_literal: true

class JournalNotesHistoriesController < ApplicationController
  include JournalNotesHistoriesHelper

  before_action :find_journal_by_journal_id

  def detail
    @page = params[:page]

    @to_id = params[:history_id].to_i
    if @to_id == 0
      render_400
      return
    end

    @history = find_history_by(@to_id)
    if @history.blank?
      render_403
      return
    end

    @from_id = find_history_id_before(@history.created_on)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def diff
    @page = params[:page]

    @to_id = params.fetch(:to_id, params[:history_id]).to_i
    if @to_id == 0
      render_400
      return
    end

    @to_history = find_history_by(@to_id)
    if @to_history.blank?
      render_403
      return
    end

    @from_id = params[:from_id]&.to_i
    @from_id ||= find_history_id_before(@to_history.created_on) if params[:history_id].present?
    @from_id = @from_id.to_i
    if @from_id == 0
      render_400
      return
    end

    @from_history = find_history_by(@from_id)
    if @from_history.blank?
      render_403
      return
    end

    @diff_type = params[:diff_type] || 'inline'
    @diff = diff_journal_notes(@from_history.container, @to_history.container)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def show
    @page = params[:page]

    query = @journal.note_histories.order(created_on: 'DESC')
    if deny_private_notes?
      query = RedmineJournalNotesHistory::Utils.filter_private_notes(query)
    end

    @history_count = query.count
    @history_pages = Paginator.new(@history_count, per_page_option, @page)
    @histories = query.limit(@history_pages.per_page).offset(@history_pages.offset).to_a
    if @histories.empty?
      render_400
      return
    end

    @from_id = params[:from_id]&.to_i
    if @histories.length > 1
      @from_id ||= @histories[1].id
      @from_id = @histories[1].id unless @histories.any? { |h| h.id == @from_id }
    end
    @from_id ||= 0

    @to_id = params[:to_id]&.to_i
    @to_id ||= @histories[0].id
    @to_id = @histories[0].id unless @histories.any? { |h| h.id == @to_id }
    return # Naming/MemoizedInstanceVariableName ?
  end

  private

  def find_journal_by_journal_id
    @journal = Journal.visible.find(params[:journal_id])
    @project = @journal.journalized.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_history_by(id)
    history = @journal.note_histories.find(id)

    if history.container.private_notes? && deny_private_notes?
      history = nil
    end

    history
  end

  def find_history_id_before(datetime)
    query = @journal.note_histories
      .where(['journal_notes_histories.created_on < ?', datetime])
      .order(created_on: 'DESC')
      .limit(1)
    if deny_private_notes?
      query = RedmineJournalNotesHistory::Utils.filter_private_notes(query)
    end

    query.first&.id.to_i
  end

  def render_400
    render_error({message: 'Bad Request', status: 400})
    return false
  end
end
