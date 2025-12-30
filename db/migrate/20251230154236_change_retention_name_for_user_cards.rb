class ChangeRetentionNameForUserCards < ActiveRecord::Migration[7.2]
  def change
    rename_column :user_cards, :retention, :retention_definition
  end
end
