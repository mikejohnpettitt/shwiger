class AddNextReviewToUserCard < ActiveRecord::Migration[7.2]
  def change
    add_column :user_cards, :next_review, :timestamp
  end
end
