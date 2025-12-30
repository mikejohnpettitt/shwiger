class AddRetentionPinyinToUserCards < ActiveRecord::Migration[7.2]
  def change
    add_column :user_cards, :retention_pinyin, :float
  end
end
