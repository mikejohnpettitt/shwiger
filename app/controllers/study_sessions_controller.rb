class StudySessionsController < ApplicationController
  def new
    @study_session = StudySession.new
  end

  def show
    @study_session = StudySession.find(params[:id])
    @study_session_deck = StudySessionDeck.where(study_session: @study_session).first
    @deck = @study_session_deck.deck
    if @study_session.mode == "learn"
      @card = Card
      .where(deck: @deck)
      .where.not(id: UserCard.where(user: current_user).select(:card_id))
      .first
    end

    if @study_session.mode == "revise"
      @card = Card
      .where(deck: @deck)
      .where(
        id: UserCard
        .where(user: current_user)
        .where("next_review IS NULL OR next_review <= ?", Time.current)
        .select(:card_id)
      )
      .first
    end
  end

  def create
    @study_session = StudySession.new(user: current_user, started_at: DateTime.now, mode: study_session_params[:mode])
    @study_session.save
    StudySessionDeck.create(study_session: @study_session, deck_id: study_session_params[:deck_id])
    redirect_to study_session_path(@study_session)
  end

  def next
    @ralgo = 1.62
    @ralgo_max = 28
    @ralgo_min = 0.4
    @deck = Deck.find(params[:deck])
    current = @deck.cards.find(params[:card_id])
    @user_card = UserCard.find_or_create_by(user: current_user, card: current, preferred_definition: Definition.where(entry: current.entry).first)
    @user_card.save!
    @study_session = StudySession.find(params[:id])
    if @study_session.mode == "learn"
      @user_card.retention = @ralgo_min
      @user_card.last_reviewed = Time.current
      @user_card.next_review = Time.current + @user_card.retention.day
      @user_card.save!
      @card = Card
      .where(deck: @deck)
      .where.not(id: UserCard.where(user: current_user).select(:card_id))
      .first
    end

    if @study_session.mode == "revise"
      @user_card.retention = @ralgo_min if @user_card.retention.nil?
      if params[:retained]
        @user_card.retention = (@user_card.retention * @ralgo).ceil
      else
        @user_card.retention = @ralgo_min
      end
      @user_card.retention = @ralgo_max if @user_card.retention > @ralgo_max
      @user_card.last_reviewed = Time.current
      @user_card.next_review = Time.current + @user_card.retention.day
      @user_card.save!
      @card = Card
      .where(deck: @deck)
      .where(
        id: UserCard
        .where(user: current_user)
        .where("next_review IS NULL OR next_review <= ?", Time.current)
        .select(:card_id)
      )
      .first
    end

    if @card.nil?
      redirect_to results_study_session_path(@study_session)
    else
      render turbo_stream: turbo_stream.update(
        "card-view",
        partial: "shared/card_learn",
        locals: { card: @card, deck: @deck, study_session: @study_session }
      )
    end
  end
end

  private

def study_session_params
  params.require(:study_session).permit(:deck_id, :mode)
end
