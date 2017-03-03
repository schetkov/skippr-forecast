namespace :admin do
  desc "Create Peninsula Capital"
  task create_peninsula_capital: :environment do
    buyer = Buyer.create(
      workflow_state: "approved",
      investor_type: "High Net Worth"
    )

    if buyer.valid?
      puts "Peninsula Capital buyer created"
    else
      "Something went wrong"
    end

    user = User.create(
      name: "Patrick Crivelli",
      email: "peninsula_capital@skippr.com.au",
      password: "Skippr2016",
      account_type: 0,
      userable: buyer
    )

    if user.valid?
      puts "Peninsula Capital user created"
    else
      "Something went wrong"
    end

    company = BuyerCompany.create(
      name: "Peninsula Capital",
      buyer: buyer
    )

    if company.valid?
      puts "Peninsula Capital company created"
    else
      "Something went wrong"
    end

    bank_details = BankDetails.create(
      account_name: "Peninsula Capital",
      account_number: "12345678",
      bankable_id: company.id,
      bankable_type: "BuyerCompany",
      bsb_number: "12345"
    )

    if bank_details.valid?
      puts "Peninsula Capital bank details added"
    else
      "Something went wrong"
    end
  end
end
