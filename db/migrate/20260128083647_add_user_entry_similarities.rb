class AddUserEntrySimilarities < ActiveRecord::Migration[7.2]
  def change
    create_table :user_entry_similarities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :entry_similarity, null: false, foreign_key: true
      t.timestamps
    end
  end
end
