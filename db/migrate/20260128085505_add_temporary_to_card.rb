class AddTemporaryToCard < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :temporary, :boolean
  end
end
