class AddEntryToCard < ActiveRecord::Migration[7.2]
  def change
    add_reference :cards, :entry, null: false, foreign_key: true
  end
end
