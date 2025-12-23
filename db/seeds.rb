# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Card.delete_all
Definition.delete_all
Entry.delete_all
Deck.delete_all
User.delete_all
@admin = User.create(email: "admin@shwiger.app") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end
@deck_hsk1 = Deck.create(name: "HSK 1", user: @admin)

# below is the process of creating a card
@entry_0001 = Entry.create(chinese: "爱", pinyin: "ài")
@definition_0001_1 = Definition.create(entry: @entry_0001, english: "to love/be fond of/like")
@definition_0001_2 = Definition.create(entry: @entry_0001, english: "affection")
@card_0001 = Card.create(deck: @deck_hsk1, entry: @entry_0001)

# below is the process of creating a card
@entry_0002 = Entry.create(chinese: "菜", pinyin: "cài")
@definition_0002_1 = Definition.create(entry: @entry_0002, english: "dish (type of food)")
@definition_0002_2 = Definition.create(entry: @entry_0002, english: "vegetable")
@definition_0002_3 = Definition.create(entry: @entry_0002, english: "cuisine")
@card_0002 = Card.create(deck: @deck_hsk1, entry: @entry_0002)

# below is the process of creating a card
@entry_0003 = Entry.create(chinese: "茶", pinyin: "chá")
@definition_0003_1 = Definition.create(entry: @entry_0003, english: "tea")
@card_0003 = Card.create(deck: @deck_hsk1, entry: @entry_0003)
