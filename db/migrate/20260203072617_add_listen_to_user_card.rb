class AddListenToUserCard < ActiveRecord::Migration[7.2]
  def change
    add_column :user_cards, :retention_listen, :float
    add_column :user_cards, :last_reviewed_listen, :timestamp
    add_column :user_cards, :next_review_listen, :timestamp
    add_column :user_cards, :forgettability_listen, :float
  end
end
