class UserDecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_deck, only: %i[show]
  def index
    @user_decks = current_user.user_decks
  end

  def show
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

  private

  def set_user_deck
    @user_deck = current_user.user_decks.find(params[:id])
  end
end
