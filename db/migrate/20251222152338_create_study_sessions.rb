class CreateStudySessions < ActiveRecord::Migration[7.2]
  def change
    create_table :study_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.timestamp :start_date
      t.timestamp :end_date

      t.timestamps
    end
  end
end
