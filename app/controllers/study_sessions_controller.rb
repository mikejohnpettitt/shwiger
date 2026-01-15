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

    if @study_session.mode == "revise-definition"
      @card = Card
      .where(deck: @deck)
      .where(
        id: UserCard
        .where(user: current_user)
        .where("next_review_definition IS NULL OR next_review_definition <= ?", Time.current)
        .select(:card_id)
      )
      .first
    end
    if @study_session.mode == "revise-pinyin"
      @card = Card
      .where(deck: @deck)
      .where(
        id: UserCard
        .where(user: current_user)
        .where("next_review_pinyin IS NULL OR next_review_pinyin <= ?", Time.current)
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

  def end_session
    @study_session = StudySession.find(params[:id])
    @study_session.ended_at = Time.current
      @study_session.save!
      redirect_to results_study_session_path(@study_session)
  end

  def learn
      @user_card.retention_definition = @ralgo_min
      @user_card.retention_pinyin = @ralgo_min
      @user_card.save!
      @card = Card
      .where(deck: @deck)
      .where.not(id: UserCard.where(user: current_user).select(:card_id))
      .first
  end

  def revise_definition
    # first time reviewing this session? if yes, tally is 0, if no tally + 1
    if @user_card.last_reviewed_definition <= @study_session.started_at || @user_card.session_review_tally.nil?
      @user_card.session_review_tally = 0
    else
      @user_card.session_review_tally = @user_card.session_review_tally + 1
    end
      @user_card.retention_definition = @ralgo_min if @user_card.retention_definition.nil?
      if ActiveModel::Type::Boolean.new.cast(params[:retained])
        @user_card.retention_definition = (@user_card.retention_definition * @ralgo).ceil
        @user_card.retention_definition = @ralgo_max if @user_card.retention_definition > @ralgo_max
        @user_card.last_reviewed_definition = Time.current
        @user_card.next_review_definition = Time.current + @user_card.retention_definition.day
      else
        @user_card.retention_definition = @ralgo_min
        @user_card.last_reviewed_definition = Time.current
        @user_card.next_review_definition = Time.current
      end
      @user_card.save!
      @cards = Card
      .where(deck: @deck)
      .where(
        id: UserCard
        .where(user: current_user)
        .where("next_review_definition IS NULL OR next_review_definition <= ?", Time.current)
        .select(:card_id)
        )
      @sort_hash = {}
      @cards.each do |card|
        @sort_hash[card.id] = UserCard.where(user: current_user, card_id: card.id).first.next_review_definition
      end
      @sort_hash = @sort_hash.sort_by { |_key, value| value }.to_h
      if @sort_hash.empty? == false
        @card = Card.find(@sort_hash.first.first)
      else
        @card = nil
      end
  end

  def revise_pinyin
          @user_card.retention_pinyin = @ralgo_min if @user_card.retention_pinyin.nil?
      if ActiveModel::Type::Boolean.new.cast(params[:retained])
        @user_card.retention_pinyin = (@user_card.retention_pinyin * @ralgo).ceil
        @user_card.retention_pinyin = @ralgo_max if @user_card.retention_pinyin > @ralgo_max
        @user_card.last_reviewed_pinyin = Time.current
        @user_card.next_review_pinyin = Time.current + @user_card.retention_pinyin.day
      else
        @user_card.retention_pinyin = @ralgo_min
        @user_card.last_reviewed_pinyin = Time.current
        @user_card.next_review_pinyin = Time.current
      end
      @user_card.save!
      @cards = Card
      .where(deck: @deck)
      .where(
        id: UserCard
        .where(user: current_user)
        .where("next_review_pinyin IS NULL OR next_review_pinyin <= ?", Time.current)
        .select(:card_id)
      )
      @sort_hash = {}
      @cards.each do |card|
        @sort_hash[card.id] = UserCard.where(user: current_user, card_id: card.id).first.next_review_pinyin
      end
      @sort_hash = @sort_hash.sort_by { |_key, value| value }.to_h
      if @sort_hash.empty? == false
        @card = Card.find(@sort_hash.first.first)
      else
        @card = nil
      end
  end

  def next
    @ralgo = 1.62
    @ralgo_max = 28
    @ralgo_min = 0.4
    @deck = Deck.find(params[:deck])
    current = @deck.cards.find(params[:card_id])
    @user_card = UserCard.find_or_create_by(user: current_user, card: current)
    @study_session = StudySession.find(params[:id])

    if @study_session.mode == "learn"
      learn
    end

    if @study_session.mode == "revise-definition"
      revise_definition
    end

    if @study_session.mode == "revise-pinyin"
      revise_pinyin
    end

    # END OF DECK
    if @card.nil? == false
        render turbo_stream: turbo_stream.update(
        "card-view",
        partial: "shared/card_#{@study_session.mode}",
        locals: { card: @card, deck: @deck, study_session: @study_session, flipped: false }
      )
    else
    end_session
    end
  end
end

  private

def study_session_params
  params.require(:study_session).permit(:deck_id, :mode)
end
