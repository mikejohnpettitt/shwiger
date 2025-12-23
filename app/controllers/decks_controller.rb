class DecksController < ApplicationController
  def index
    @decks = Deck.all
  end

  def show
    @deck = Deck.find(params[:id])
    @card = @deck.cards.order(:id).first
  end

  def next
  @deck = Deck.find(params[:id])
    current = @deck.cards.find(params[:card_id])
    @card = @deck.cards.where("id > ?", current.id).order(:id).first || @deck.cards.order(:id).first
    render turbo_stream: turbo_stream.update(
      "card-view",
      partial: "shared/card",
      locals: { card: @card, deck: @deck }
    )
  end
end
