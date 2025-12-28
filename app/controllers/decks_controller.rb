class DecksController < ApplicationController
  def index
    @decks = Deck.all
  end

  def show
    @deck = Deck.find(params[:id])
    @card = @deck.cards.order(:id).first
  end

  def next
    @ralgo = 1.62
    @ralgo_max = 28
    @ralgo_min = 0.4
    @deck = Deck.find(params[:id])
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
    @card = @deck.cards.where("id > ?", current.id).order(:id).first || @deck.cards.order(:id).first
    render turbo_stream: turbo_stream.update(
      "card-view",
      partial: "shared/card",
      locals: { card: @card, deck: @deck }
    )
  end
end
