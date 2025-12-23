class RenameStudySessionDatesToTimestamps < ActiveRecord::Migration[7.2]
  def change
    rename_column :study_sessions, :start_date, :started_at
    rename_column :study_sessions, :end_date, :ended_at
  end
end
