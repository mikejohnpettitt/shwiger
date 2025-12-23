class CreateEntrySimilarities < ActiveRecord::Migration[7.2]
  def change
    create_table :entry_similarities do |t|
      t.references :entry, null: false, foreign_key: { to_table: :entries }
      t.references :similar_entry, null: false, foreign_key: { to_table: :entries }
      t.string :similarity_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
