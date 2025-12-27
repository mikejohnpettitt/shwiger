# db/seeds.rb
require "json"

admin = User.find_or_create_by(email: "admin@shwiger.app")
admin.password = "password123"
admin.password_confirmation = "password123"
admin.save!

# create just the deck for HSK1

path = Rails.root.join("db", "seeds", "decks", "hsk1.json")
data = JSON.parse(File.read(path))

deck = Deck.find_or_create_by!(
  name: data.dig("deck", "name"),
  user_id: admin.id
)

ActiveRecord::Base.transaction do
  data.fetch("cards").each do |row|
    entry_data = row.fetch("entry")

    entry = Entry.find_or_create_by!(
      chinese: entry_data.fetch("chinese"),
      pinyin: entry_data.fetch("pinyin")
    )

    row.fetch("definitions").each do |english|
      Definition.find_or_create_by!(entry_id: entry.id, english: english)
    end

    Card.find_or_create_by!(deck_id: deck.id, entry_id: entry.id)
  end
end

# end of HSK1

# create just the deck for HSK2

path = Rails.root.join("db", "seeds", "decks", "hsk2.json")
data = JSON.parse(File.read(path))

deck = Deck.find_or_create_by!(
  name: data.dig("deck", "name"),
  user_id: admin.id
)

ActiveRecord::Base.transaction do
  data.fetch("cards").each do |row|
    entry_data = row.fetch("entry")

    entry = Entry.find_or_create_by!(
      chinese: entry_data.fetch("chinese"),
      pinyin: entry_data.fetch("pinyin")
    )

    row.fetch("definitions").each do |english|
      Definition.find_or_create_by!(entry_id: entry.id, english: english)
    end

    Card.find_or_create_by!(deck_id: deck.id, entry_id: entry.id)
  end
end

# end of HSK2

# create just the deck for HSK3

path = Rails.root.join("db", "seeds", "decks", "hsk3.json")
data = JSON.parse(File.read(path))

deck = Deck.find_or_create_by!(
  name: data.dig("deck", "name"),
  user_id: admin.id
)

ActiveRecord::Base.transaction do
  data.fetch("cards").each do |row|
    entry_data = row.fetch("entry")

    entry = Entry.find_or_create_by!(
      chinese: entry_data.fetch("chinese"),
      pinyin: entry_data.fetch("pinyin")
    )

    row.fetch("definitions").each do |english|
      Definition.find_or_create_by!(entry_id: entry.id, english: english)
    end

    Card.find_or_create_by!(deck_id: deck.id, entry_id: entry.id)
  end
end

# end of HSK2
