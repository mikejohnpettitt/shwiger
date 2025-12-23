class CreateStudySessionDecks < ActiveRecord::Migration[7.2]
  def change
    create_table :study_session_decks do |t|
      t.references :study_session, null: false, foreign_key: true
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
