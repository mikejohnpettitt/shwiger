class CreateUserDecks < ActiveRecord::Migration[7.2]
  def change
    create_table :user_decks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
