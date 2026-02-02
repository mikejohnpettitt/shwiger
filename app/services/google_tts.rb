# app/services/google_tts.rb
require "google/cloud/text_to_speech"

class GoogleTts
  def initialize(client: nil, logger: Rails.logger)
    @client = client || Google::Cloud::TextToSpeech.text_to_speech
    @logger = logger
  end

  def synthesize_mp3(text:, language_code:, voice_name:, speaking_rate: 1.0)
    input = Google::Cloud::TextToSpeech::V1::SynthesisInput.new(text: text)

    voice = Google::Cloud::TextToSpeech::V1::VoiceSelectionParams.new(
      language_code: language_code,
      name: voice_name
    )

    audio_config = Google::Cloud::TextToSpeech::V1::AudioConfig.new(
      audio_encoding: Google::Cloud::TextToSpeech::V1::AudioEncoding::MP3,
      speaking_rate: speaking_rate
    )

    resp = @client.synthesize_speech(input: input, voice: voice, audio_config: audio_config)
    resp.audio_content
  end
end
