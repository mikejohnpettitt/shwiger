# db/seeds.rb
require "json"
require 'fuzzystringmatch'
require 'similar_text'
jarow = FuzzyStringMatch::JaroWinkler.create(:native)

admin = User.find_or_create_by(email: "admin@shwiger.app")
admin.password = "password123"
admin.password_confirmation = "password123"
admin.save!

# create just the deck for HSK1 test

path = Rails.root.join("db", "seeds", "decks", "hsk1_test.json")
wubi_path = Rails.root.join("db", "seeds", "wubi_ref.json")
data = JSON.parse(File.read(path))
wubi_data = JSON.parse(File.read(wubi_path))

deck = Deck.find_or_create_by!(
  name: data.dig("deck", "name"),
  user_id: admin.id
)

ActiveRecord::Base.transaction do
  data.fetch("cards").each do |row|
    entry_data = row.fetch("entry")

    if entry_data.fetch("chinese").length == 1
      entry = Entry.find_or_create_by!(
      chinese: entry_data.fetch("chinese"),
      pinyin: entry_data.fetch("pinyin"),
      wubi: wubi_data.fetch(entry_data.fetch("chinese"))
      )
    else
      wubi_array = []
      entry_data.fetch("chinese").split("").each do |character|
        wubi_array << wubi_data.fetch(character, nil)
      end
      entry = Entry.find_or_create_by!(
      chinese: entry_data.fetch("chinese"),
      pinyin: entry_data.fetch("pinyin"),
      wubi: wubi_array.join(" ")
      )
    end

    row.fetch("definitions").each do |english|
      Definition.find_or_create_by!(entry_id: entry.id, english: english)
    end

    Card.find_or_create_by!(deck_id: deck.id, entry_id: entry.id)
  end
end

# end of HSK1 test

# create just the deck for HSK1

path = Rails.root.join("db", "seeds", "decks", "hsk1.json")
wubi_path = Rails.root.join("db", "seeds", "wubi_ref.json")
data = JSON.parse(File.read(path))
wubi_data = JSON.parse(File.read(wubi_path))

deck = Deck.find_or_create_by!(
  name: data.dig("deck", "name"),
  user_id: admin.id,
  color: "blue"
)

ActiveRecord::Base.transaction do
  data.fetch("cards").each do |row|
    entry_data = row.fetch("entry")

    if entry_data.fetch("chinese").length == 1
      entry = Entry.find_or_create_by!(
      chinese: entry_data.fetch("chinese"),
      pinyin: entry_data.fetch("pinyin"),
      wubi: wubi_data.fetch(entry_data.fetch("chinese"))
      )
    else
      wubi_array = []
      entry_data.fetch("chinese").split("").each do |character|
        wubi_array << wubi_data.fetch(character, nil)
      end
      entry = Entry.find_or_create_by!(
      chinese: entry_data.fetch("chinese"),
      pinyin: entry_data.fetch("pinyin"),
      wubi: wubi_array.join(" ")
      )
    end

    row.fetch("definitions").each do |english|
      Definition.find_or_create_by!(entry_id: entry.id, english: english)
    end

    Card.find_or_create_by!(deck_id: deck.id, entry_id: entry.id)
  end
end

# end of HSK1

# create just the deck for HSK2

path = Rails.root.join("db", "seeds", "decks", "hsk2.json")
wubi_path = Rails.root.join("db", "seeds", "wubi_ref.json")
data = JSON.parse(File.read(path))
wubi_data = JSON.parse(File.read(wubi_path))

deck = Deck.find_or_create_by!(
  name: data.dig("deck", "name"),
  user_id: admin.id,
    color: "green"
)

ActiveRecord::Base.transaction do
  data.fetch("cards").each do |row|
    entry_data = row.fetch("entry")

    if entry_data.fetch("chinese").length == 1
      entry = Entry.find_or_create_by!(
      chinese: entry_data.fetch("chinese"),
      pinyin: entry_data.fetch("pinyin"),
      wubi: wubi_data.fetch(entry_data.fetch("chinese"))
      )
    else
      wubi_array = []
      entry_data.fetch("chinese").split("").each do |character|
        wubi_array << wubi_data.fetch(character, nil)
      end
      entry = Entry.find_or_create_by!(
      chinese: entry_data.fetch("chinese"),
      pinyin: entry_data.fetch("pinyin"),
      wubi: wubi_array.join(" ")
      )
    end

    row.fetch("definitions").each do |english|
      Definition.find_or_create_by!(entry_id: entry.id, english: english)
    end

    Card.find_or_create_by!(deck_id: deck.id, entry_id: entry.id)
  end
end

# end of HSK2

# create just the deck for HSK3

path = Rails.root.join("db", "seeds", "decks", "hsk3.json")
wubi_path = Rails.root.join("db", "seeds", "wubi_ref.json")
data = JSON.parse(File.read(path))
wubi_data = JSON.parse(File.read(wubi_path))

deck = Deck.find_or_create_by!(
  name: data.dig("deck", "name"),
  user_id: admin.id,
    color: "orange"
)

ActiveRecord::Base.transaction do
  data.fetch("cards").each do |row|
    entry_data = row.fetch("entry")

    if entry_data.fetch("chinese").length == 1
      entry = Entry.find_or_create_by!(
      chinese: entry_data.fetch("chinese"),
      pinyin: entry_data.fetch("pinyin"),
      wubi: wubi_data.fetch(entry_data.fetch("chinese"))
      )
    else
      wubi_array = []
      entry_data.fetch("chinese").split("").each do |character|
        wubi_array << wubi_data.fetch(character, nil)
      end
      entry = Entry.find_or_create_by!(
      chinese: entry_data.fetch("chinese"),
      pinyin: entry_data.fetch("pinyin"),
      wubi: wubi_array.join(" ")
      )
    end

    row.fetch("definitions").each do |english|
      Definition.find_or_create_by!(entry_id: entry.id, english: english)
    end

    Card.find_or_create_by!(deck_id: deck.id, entry_id: entry.id)
  end
end

# end of HSK3


# create character similarities
# single character first

Entry.where("length(chinese) = 1").each do |entry|
  # look for similar wubis
  Entry.where("length(chinese) = 1").each do |e|
    # this line makes sure there are no duplicates in the other direction
    a, b = [ entry, e ].sort_by(&:id)
    if jarow.getDistance(a.chinese, b.chinese) >= 0.821 && a.chinese != b.chinese
      EntrySimilarity.find_or_create_by!(
        entry: a,
        similar_entry: b,
        similarity_type: "string",
        user: admin
      )
    end
  end
end

# multiple character

Entry.where("length(chinese) > 1").each do |entry|
  # look for similar wubis
  Entry.where("length(chinese) > 1").each do |e|
    # this line makes sure there are no duplicates in the other direction
    a, b = [ entry, e ].sort_by(&:id)
    if jarow.getDistance(a.chinese, b.chinese) >= 0.823 && a.chinese != b.chinese
      EntrySimilarity.find_or_create_by!(
        entry: a,
        similar_entry: b,
        similarity_type: "string",
        user: admin
      )
    end
  end
end



p "Number of entry similarities: #{EntrySimilarity.count}"
EntrySimilarity.all.each do |es|
  p "#{es.entry.chinese} - #{es.similar_entry.chinese}"
end
