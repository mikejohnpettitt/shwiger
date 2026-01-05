class UserCardsController < ApplicationController
  def update
    @card = Card.find(params[:card])
    @deck = Deck.find(params[:deck])
    @study_session = StudySession.find(params[:study_session])
    @user_card = current_user.user_cards.find(params[:id])
    @user_card.update!(preferred_definition: Definition.find(params[:preferred_definition_id]))
    render turbo_stream: turbo_stream.update(
          "card-view",
          partial: "shared/card_#{@study_session.mode}",
          locals: { card: @card, deck: @deck, study_session: @study_session, flipped: true }
      )
  end
end
