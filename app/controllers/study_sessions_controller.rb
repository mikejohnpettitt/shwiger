class StudySessionsController < ApplicationController
  def new
    @study_session = StudySession.new
  end

  def show
    @study_session = StudySession.find(params[:id])
    @study_session_deck = StudySessionDeck.where(study_session: @study_session).first
    @deck = @study_session_deck.deck
    # # if learn, prepare 10 new cards from the deck
    # if @study_session.mode == "learn"
    #   # prepare deck
    #   # get deck, get 10 where a no user card currently exists
    #   @deck_size = 10
    #   @learn_deck = []
    #   @counter = 0
    #   while @learn_deck.length < @deck_size do
    #     @card = Card.where(deck: @deck)[@counter]
    #     @learn_deck << @card if UserCard.where(user: current_user, card: @card).length == 0
    #     @counter += 1
    #   end
    # end
    # # if revise, show all user cards where the review date is smaller than current date
    # if @study_session.mode == "mode"

    # end
  end

  def create
    @study_session = StudySession.new(user: current_user, started_at: DateTime.now, mode: study_session_params[:mode])
    @study_session.save
    StudySessionDeck.create(study_session: @study_session, deck_id: study_session_params[:decks])
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
    @user_card.retention = @ralgo_min if @user_card.retention.nil?
    if params[:retained]
      @user_card.retention = (@user_card.retention * @ralgo).ceil
    else
      @user_card.retention = @ralgo_min
    end
    @user_card.retention = @ralgo_max if @user_card.retention > @ralgo_max
    @user_card.last_reviewed = Time.current
    @user_card.next_review = Time.current + @user_card.retention.day
    # @card = @deck.cards.where("id > ?", current.id).order(:id).first || @deck.cards.order(:id).first
    @card = Card
    .where(deck: @deck)
    .where.not(id: UserCard.where(user: current_user).select(:card_id))
    .first
    @study_session = StudySession.find(params[:study_session])
    render turbo_stream: turbo_stream.update(
      "card-view",
      partial: "shared/card_learn",
      locals: { card: @card, deck: @deck, study_session: @study_session }
    )
  end
end

  private

def study_session_params
  params.require(:study_session).permit(:decks, :mode)
end
