class TtsClipsController < ApplicationController
  def create
    text = params.require(:text).to_s
    voice_name = params[:voice_name].presence || "cmn-CN-Chirp3-HD-Vindemiatrix"
    language_code = params[:language_code].presence || "cmn-CN"
    speaking_rate = (params[:speaking_rate].presence || 1.0).to_f

    digest = Digest::SHA256.hexdigest([ text, voice_name, language_code, speaking_rate, "google_v1_mp3" ].join("|"))

    clip = TtsClip.find_or_initialize_by(digest: digest)
    if clip.new_record?
      clip.assign_attributes(
        text: text,
        voice_name: voice_name,
        language_code: language_code,
        speaking_rate: speaking_rate,
        status: :pending
      )
      clip.save!
    end

    if clip.ready? && clip.audio.attached?
      render json: { id: clip.id, status: clip.status, audio_url: url_for(clip.audio) }
    else
      GenerateTtsClipJob.perform_later(clip.id)
      render json: { id: clip.id, status: clip.status }, status: :accepted
    end
  end

  def show
    clip = TtsClip.find(params[:id])
    payload = { id: clip.id, status: clip.status }
    payload[:audio_url] = url_for(clip.audio) if clip.ready? && clip.audio.attached?
    render json: payload
  end
end
