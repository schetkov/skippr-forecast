namespace :admin do
  desc 'Create admin users'
  task create_admin_users: :environment do
    admin = User.new(
      name: 'Pat Crivelli',
      email: 'p.crivelli@skippr.com.au',
      password: 'Skippr2016',
      account_type: "admin"
    )

    second_admin = User.new(
      name: 'Alistair Lamond',
      email: 'a.lamond@skippr.com.au',
      password: 'Skippr2016',
      account_type: "admin"
    )

    third_admin = User.new(
      name: 'Ralph Wintle',
      email: 'r.wintle@skippr.com.au',
      password: 'Skippr2016',
      account_type: "admin"
    )

    forth_admin = User.new(
      name: 'Admin',
      email: 'admin@example.com',
      password: 'Password100',
      account_type: "admin"
    )

    admins = []
    admins << admin
    admins << second_admin
    admins << third_admin
    admins << forth_admin

    admins.each do |admin_user|
      if admin_user.valid?
        puts "Creating admin user: #{admin_user.name}"
        admin_user.save!
        puts 'Admin Created'
      else
        puts 'Something went wrong'
      end
    end
  end
end

