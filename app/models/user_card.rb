class UserCard < ApplicationRecord
  belongs_to :user
  belongs_to :card
  belongs_to :preferred_definition, class_name: "Definition"

  validates :card_id, uniqueness: { scope: :user_id }
end
