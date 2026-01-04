class UserCardsController < ApplicationController
def update
  @card = Card.find(params[:card])
  @deck = Deck.find(params[:deck])
  @study_session = StudySession.find(params[:study_session])
  @user_card = current_user.user_cards.find(params[:id])
  @user_card.update!(user_card_params)
  render turbo_stream: turbo_stream.update(
        "card-view",
        partial: "shared/card_#{@study_session.mode}",
        locals: { card: @card, deck: @deck, study_session: @study_session, flipped: true }
    )
end

def user_card_params
  params.require(:user_card).permit(:preferred_definition_id)
end
end
