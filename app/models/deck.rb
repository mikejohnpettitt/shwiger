class Deck < ApplicationRecord
  belongs_to :user
  has_many :study_sessions_decks
  has_many :cards
  # has_many :study_sessions, through: :study_sessions_decks
end
