class StudySession < ApplicationRecord
  belongs_to :user
  has_many :study_session_decks, dependent: :destroy
  has_many :decks, through: :study_session_decks
end
