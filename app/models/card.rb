class Card < ApplicationRecord
  belongs_to :deck
  belongs_to :entry
  has_many :user_cards
end
