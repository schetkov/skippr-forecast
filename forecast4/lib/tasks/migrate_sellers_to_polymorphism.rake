namespace :users do
  task polymorphic_sellers: :environment do
    users = User.seller
    puts "Going to update #{users.count} users"

    users.each do |user|
      user.update(userable_id: user.seller_id, userable_type: "Seller")
      print "."
    end

    put "\nAll done now!"
  end
end
