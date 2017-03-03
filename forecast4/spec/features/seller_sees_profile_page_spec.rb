require "rails_helper"

feature "Seller sees company profile page" do
  scenario "approved seller with verified company" do
    seller = create(:seller)
    seller.seller_company.destroy
    create(:seller_company,
           name: "Woolies Ltd",
           description: "My awesome company",
           address: "101 Address",
           website: "http://www.woolies.com",
           acn: "123456789",
           seller: seller)

    visit seller_dashboard_path(as: seller.user)
    click_link "Woolies Ltd"

    seller_sees_company_page(seller)
    seller_sees_company_profile_information(
      company_name: "Woolies Ltd",
      company_description: "My awesome company",
      company_address: "101 Address",
      company_website: "http://www.woolies.com",
      acn: "123456789",
    )
  end

  scenario "with attachments" do
    seller = create(:seller)
    create(:attachment,
           :bank_statements,
           file_name: "folder/file_name",
           attachable: seller.seller_company)
    create(:attachment,
           :financial_statements,
           file_name: "folder/file_name",
           attachable: seller.seller_company)
    create(:attachment,
           file_name: "folder/file_name",
           attachable: seller.seller_company)
    create(:attachment,
           :aged_payable_report,
           file_name: "folder/file_name",
           attachable: seller.seller_company)

    visit seller_path(seller, as: seller.user)

    within(".financial-statements") do
      expect(page).to have_content "File name"
    end
    within(".bank-statements") do
      expect(page).to have_content "File name" end
    within(".other-supporting-documents") do
      expect(page).to have_content "File name"
    end
  end

  scenario "without ageing debtor and financial attachments" do
    seller = create(:seller)

    visit seller_path(seller, as: seller.user)

    within(".financial-statements") do
      expect(page).to have_content "There are no financial statements to display."
    end
    within(".bank-statements") do
      expect(page).to have_content "There are no bank statements to display."
    end
    within(".other-supporting-documents") do
      expect(page).to have_content "There are no supporting documents to display."
    end
  end

  def seller_sees_company_page(seller)
    expect(current_path).to eq seller_path(seller)
  end

  def seller_sees_company_profile_information(args)
    expect(page).to have_content args.fetch(:company_name)
    expect(page).to have_content args.fetch(:company_description)
    expect(page).to have_content args.fetch(:company_address)
    expect(page).to have_content args.fetch(:company_website)
    expect(page).to have_content args.fetch(:acn)
  end
end
