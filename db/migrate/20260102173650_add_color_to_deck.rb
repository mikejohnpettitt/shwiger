class AddColorToDeck < ActiveRecord::Migration[7.2]
  def change
    add_column :decks, :color, :string
  end
end
