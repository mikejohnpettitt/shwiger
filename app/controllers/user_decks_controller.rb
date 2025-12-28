class UserDecksController < ApplicationController
  def index
    @user_decks = UserDeck.all
  end

  def show
    @user_deck = UserDeck.find(params[:id])
    @deck = @user_deck.deck
  end

  def create
    @user = current_user
    @deck = Deck.find(params[:deck_id])
    # @user_deck = UserDeck.create(user: @user, deck: @deck)
    @user_deck = UserDeck.find_or_create_by(user: @user, deck: @deck)
    @user_deck.save
    redirect_to user_deck_path(@user_deck)
  end
end
