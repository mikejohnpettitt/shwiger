class Entry < ApplicationRecord
  has_many :entry_similarities,
          class_name: "EntrySimilarity",
          foreign_key: :entry_id,
          dependent: :destroy

  has_many :entry_similarities_as_similar_entry,
          class_name: "EntrySimilarity",
          foreign_key: :similar_entry_id,
          dependent: :destroy

  has_many :cards, dependent: :destroy
  has_many :definitions, dependent: :destroy
end
