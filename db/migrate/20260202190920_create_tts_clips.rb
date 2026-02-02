class CreateTtsClips < ActiveRecord::Migration[7.2]
  def change
    create_table :tts_clips do |t|
      t.string  :digest,        null: false
      t.text    :text,          null: false

      t.string  :language_code, null: false, default: "cmn-CN"
      t.string  :voice_name,    null: false, default: "cmn-CN-Wavenet-A"

      t.float   :speaking_rate, null: false, default: 1.0
      t.integer :status,        null: false, default: 0 # pending=0, ready=1, failed=2

      t.timestamps
    end

    add_index :tts_clips, :digest, unique: true
  end
end
