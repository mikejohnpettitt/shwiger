class SplitReviewTimesForUserCards < ActiveRecord::Migration[7.2]
  def change
    rename_column :user_cards, :last_reviewed, :last_reviewed_definition
    rename_column :user_cards, :next_review, :next_review_definition
    add_column :user_cards, :last_reviewed_pinyin, :timestamp
    add_column :user_cards, :next_review_pinyin, :timestamp
  end
end
