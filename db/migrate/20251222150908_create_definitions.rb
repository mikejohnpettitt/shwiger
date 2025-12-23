class CreateDefinitions < ActiveRecord::Migration[7.2]
  def change
    create_table :definitions do |t|
      t.references :entry, null: false, foreign_key: true
      t.string :english

      t.timestamps
    end
  end
end
