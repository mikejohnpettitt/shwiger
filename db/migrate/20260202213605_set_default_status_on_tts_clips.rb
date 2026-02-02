class SetDefaultStatusOnTtsClips < ActiveRecord::Migration[7.2]
  def up
    change_column_default :tts_clips, :status, 0
    execute "UPDATE tts_clips SET status = 0 WHERE status IS NULL"
    change_column_null :tts_clips, :status, false
  end

  def down
    change_column_null :tts_clips, :status, true
    change_column_default :tts_clips, :status, nil
  end
end
