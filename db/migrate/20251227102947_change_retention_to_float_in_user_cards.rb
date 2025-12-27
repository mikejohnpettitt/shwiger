class ChangeRetentionToFloatInUserCards < ActiveRecord::Migration[7.2]
  def change
        change_column :user_cards, :retention, :float
  end
end
