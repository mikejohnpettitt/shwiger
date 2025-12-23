class UserCard < ApplicationRecord
  belongs_to :user
  belongs_to :card
  belongs_to :preferred_definition, class_name: "Definition"
end
