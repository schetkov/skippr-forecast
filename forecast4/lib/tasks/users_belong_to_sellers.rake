namespace :users do
  task belongs_to_seller: :environment do
    sellers = Seller.all
    puts "Going to update #{sellers.count} sellers"

    ActiveRecord::Base.transaction do
      sellers.each do |seller|
        user = User.find(seller.user_id)
        user.update(seller_id: seller.id)
        print "."
      end
    end

    puts "All done now!"
  end
end
