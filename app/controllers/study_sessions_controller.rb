class StudySessionsController < ApplicationController
  def new
    @study_session = StudySession.new
  end

  def show
    @study_session = StudySession.find(params[:id])
  end

  def create
    @study_session = StudySession.new(user: current_user, started_at: DateTime.now)
    @study_session.save
    StudySessionDeck.create(study_session: @study_session, deck_id: study_session_params[:decks])
    redirect_to study_session_path(@study_session)
  end
end

  private

def study_session_params
  params.require(:study_session).permit(:decks)
end
