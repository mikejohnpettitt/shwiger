class Definition < ApplicationRecord
  belongs_to :entry
  has_many :user_cards,
         class_name: "UserCard",
         foreign_key: :preferred_definition_id
end
