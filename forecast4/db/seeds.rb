# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Set the exchange fees for the application
Preference.create(seller_exchange_fee: 0.008, buyer_exchange_fee: 0.008)

# Set the initial values for the Invoice Rating
MasterRating.create(rating_value: "1", discount_rate: 0.008, advance_amount: 0.90)
MasterRating.create(rating_value: "2", discount_rate: 0.010, advance_amount: 0.85)
MasterRating.create(rating_value: "3", discount_rate: 0.012, advance_amount: 0.80)
MasterRating.create(rating_value: "4", discount_rate: 0.015, advance_amount: 0.75)
MasterRating.create(rating_value: "5", discount_rate: 0.020, advance_amount: 0.70)
