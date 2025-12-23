class CreateUserCards < ActiveRecord::Migration[7.2]
  def change
    create_table :user_cards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true
      t.references :preferred_definition, null: false, foreign_key: { to_table: :definitions }
      t.integer :retention
      t.timestamp :last_reviewed

      t.timestamps
    end
  end
end
