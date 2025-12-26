class UserDeck < ApplicationRecord
  belongs_to :user
  belongs_to :deck

  validates :deck_id, uniqueness: { scope: :user_id }
end
