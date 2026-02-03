class GenerateTtsClipJob < ApplicationJob
  queue_as :default

  def perform(clip_id)
    clip = TtsClip.find(clip_id)
    return if clip.ready? && clip.audio.attached?

    bytes = GoogleTts.new.synthesize_mp3(
      text: clip.text,
      language_code: clip.language_code,
      voice_name: clip.voice_name,
      speaking_rate: clip.speaking_rate || 1.0
    )

    clip.audio.attach(
      io: StringIO.new(bytes),
      filename: "#{clip.digest}.mp3",
      content_type: "audio/mpeg"
    )

    clip.update!(status: :ready)
  rescue => e
    clip.update!(status: :failed) rescue nil
    raise e
  end
end
