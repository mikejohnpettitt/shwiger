class AddSessionReviewTallyAndForgettabilityToUserCards < ActiveRecord::Migration[7.2]
  def change
    add_column :user_cards, :session_review_tally, :integer
    add_column :user_cards, :forgetability_definition, :integer
    add_column :user_cards, :forgetability_pinyin, :integer
  end
end
