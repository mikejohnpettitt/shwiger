class TtsClip < ApplicationRecord
  has_one_attached :audio

  enum status: { pending: 0, ready: 1, failed: 2 }

  validates :digest, presence: true, uniqueness: true
  validates :text, presence: true
end
