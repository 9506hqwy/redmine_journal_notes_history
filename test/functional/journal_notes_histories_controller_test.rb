# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class JournalNotesHistoriesControllerTest < Redmine::ControllerTest
  include Redmine::I18n

  fixtures :enabled_modules,
           :enumerations,
           :issue_statuses,
           :issues,
           :journal_details,
           :journals,
           :member_roles,
           :members,
           :projects,
           :projects_trackers,
           :roles,
           :trackers,
           :users,
           :versions,
           :journal_notes_histories,
           :journal_notes_versions

  def setup
    @request.session[:user_id] = 2
  end

  def test_detail_history_nil
    j = journals(:journals_001)

    get :detail, params: {
      journal_id: j.id,
    }

    assert_response 400
  end

  def test_detail_history_not_found
    j = journals(:journals_001)

    get :detail, params: {
      journal_id: j.id,
      history_id: -1,
    }

    assert_response 404
  end

  def test_detail_history_deny_private_notes
    @request.session[:user_id] = 3

    j = journals(:journals_001)
    p = j.note_versions.where(private_notes: true).first

    get :detail, params: {
      journal_id: j.id,
      history_id: p.note_history.id,
    }

    assert_response 403
  end

  def test_detail_history
    j = journals(:journals_001)
    p = j.note_versions.first

    get :detail, params: {
      journal_id: j.id,
      history_id: p.note_history.id,
    }

    assert_response :success
    assert_select "div#journal-#{p.id}-notes"
  end

  def test_diff_to_nil
    j = journals(:journals_001)
    v = j.note_versions.all

    get :diff, params: {
      journal_id: j.id,
      from_id: v[0].note_history.id,
    }

    assert_response 400
  end

  def test_diff_to_not_found
    j = journals(:journals_001)
    v = j.note_versions.all

    get :diff, params: {
      journal_id: j.id,
      from_id: v[0].note_history.id,
      to_id: -1,
    }

    assert_response 404
  end

  def test_diff_to_deny_private_notes
    @request.session[:user_id] = 3

    j = journals(:journals_001)
    v = j.note_versions.all
    p = j.note_versions.where(private_notes: true).first

    get :diff, params: {
      journal_id: j.id,
      from_id: v[0].note_history.id,
      to_id: p.note_history.id,
    }

    assert_response 403
  end

  def test_diff_from_nil
    j = journals(:journals_001)
    v = j.note_versions.all

    get :diff, params: {
      journal_id: j.id,
      to_id: v[-1].note_history.id,
    }

    assert_response 400
  end

  def test_diff_from_not_found
    j = journals(:journals_001)
    v = j.note_versions.all

    get :diff, params: {
      journal_id: j.id,
      from_id: -1,
      to_id: v[-1].note_history.id,
    }

    assert_response 404
  end

  def test_diff_from_deny_private_notes
    @request.session[:user_id] = 3

    j = journals(:journals_001)
    v = j.note_versions.all
    p = j.note_versions.where(private_notes: true).first

    get :diff, params: {
      journal_id: j.id,
      from_id: p.note_history.id,
      to_id: v[-1].note_history.id,
    }

    assert_response 403
  end

  def test_diff_history_nil
    j = journals(:journals_001)
    v = j.note_versions.all

    get :diff, params: {
      journal_id: j.id,
    }

    assert_response 400
  end

  def test_diff_history_not_found
    j = journals(:journals_001)
    v = j.note_versions.all

    get :diff, params: {
      journal_id: j.id,
      history_id: -1,
    }

    assert_response 404
  end

  def test_diff_history_deny_private_notes
    @request.session[:user_id] = 3

    j = journals(:journals_001)
    v = j.note_versions.all
    p = j.note_versions.where(private_notes: true).first

    get :diff, params: {
      journal_id: j.id,
      history_id: p.note_history.id,
    }

    assert_response 403
  end

  def test_diff_from_to
    j = journals(:journals_001)
    v = j.note_versions.all

    get :diff, params: {
      journal_id: j.id,
      from_id: v[0].note_history.id,
      to_id: v[-1].note_history.id,
    }

    assert_response :success
    assert_select "input#from_id[value=#{v[0].note_history.id}]"
    assert_select "input#to_id[value=#{v[-1].note_history.id}]"
  end

  def test_diff_history
    j = journals(:journals_001)
    v = j.note_versions.order(:id).all

    get :diff, params: {
      journal_id: j.id,
      history_id: v[-1].note_history.id,
    }

    assert_response :success
    assert_select "input#from_id[value=#{v[-2].note_history.id}]"
    assert_select "input#to_id[value=#{v[-1].note_history.id}]"
  end

  def test_diff_history_private_notes
    @request.session[:user_id] = 3

    j = journals(:journals_001)
    v = j.note_versions.order(:id).all

    get :diff, params: {
      journal_id: j.id,
      history_id: v[-1].note_history.id,
    }

    assert_response :success
    assert_select "input#from_id[value=#{v[-3].note_history.id}]"
    assert_select "input#to_id[value=#{v[-1].note_history.id}]"
  end

  def test_show
    j = journals(:journals_001)
    h = j.note_histories.order(created_on: 'DESC').all

    get :show, params: {
      journal_id: j.id,
    }

    assert_response :success
    assert_select 'tbody tr', h.count
    assert_select "input[type=radio][name=to_id][checked=checked][value=#{h[0].id}]"
    assert_select "input[type=radio][name=from_id][checked=checked][value=#{h[1].id}]"
  end

  def test_show_to_from
    j = journals(:journals_001)
    h = j.note_histories.order(created_on: 'DESC').all

    get :show, params: {
      journal_id: j.id,
      from_id: h[-1].id,
      to_id: h[-2].id,
    }

    assert_response :success
    assert_select 'tbody tr', h.count
    assert_select "input[type=radio][name=to_id][checked=checked][value=#{h[-2].id}]"
    assert_select "input[type=radio][name=from_id][checked=checked][value=#{h[-1].id}]"
  end

  def test_show_private_notes
    j = journals(:journals_001)
    h = j.note_histories.order(created_on: 'DESC').all

    @request.session[:user_id] = 3

    get :show, params: {
      journal_id: j.id,
    }

    assert_response :success
    assert_select 'tbody tr', h.count - 1
    assert_select "input[type=radio][name=to_id][checked=checked][value=#{h[0].id}]"
    assert_select "input[type=radio][name=from_id][checked=checked][value=#{h[2].id}]"
  end

  def test_journal_deny_private_notes
    j = journals(:journals_001)
    j.private_notes = true
    j.save!

    @request.session[:user_id] = 3

    get :show, params: {
      journal_id: j.id,
    }

    assert_response 404
  end
end
