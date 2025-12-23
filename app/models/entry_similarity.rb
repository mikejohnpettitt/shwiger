class EntrySimilarity < ApplicationRecord
  belongs_to :entry, class_name: "Entry"
  belongs_to :similar_entry, class_name: "Entry"
  belongs_to :user
end
