class AddModeToStudySessions < ActiveRecord::Migration[7.2]
  def change
      add_column :study_sessions, :mode, :string
  end
end
