ActiveAdmin.register_page "Dashboard" do

  menu priority: 0, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Latest Trades" do
          table_for Trade.confirmed.order("created_at DESC") do |trade|
            column :confirmed_at do |trade|
              link_to trade.confirmed_at, admin_trade_path(trade)
            end
            column :total_face_value
            column :advance_amount
            column :discount_fee
            column :seller
            column :funded_on
            column :funded_status
          end
        end
      end
    end

    columns do
      column do
         panel 'Latest Sellers' do
           table_for Seller.ordered do
             column('Name') do |seller|
               link_to seller.name, admin_seller_path(seller)
             end
             column :email
             column :seller_company
             column('Company Status') do |seller|
               status_tag seller_company_status(seller.seller_company)
             end
           end
         end
      end
      column do
        panel 'Latest Buyers' do
          table_for Buyer.ordered do
            column :name
            column :email
            column :company
          end
        end
      end
    end

    columns do
      column do
        panel 'Latest Seller Companies' do
           table_for SellerCompany.ordered do
             column('Name') { |company| link_to company.name, admin_seller_company_path(company) }
             column 'Contact Person', :user
             column :phone_number
             column :description
             column :created_at
             column('Status') do |company|
               status_tag seller_company_status(company)
             end
           end
        end
      end
      column do
        panel 'Latest Buyer Companies' do
           table_for BuyerCompany.ordered do
             column('Name') { |company| link_to company.name, admin_seller_company_path(company) }
             column 'Contact Person', :user
             column :phone_number
             column :description
             column :created_at
             column('Status') do |company|
               status_tag seller_company_status(company)
             end
           end
        end
      end
    end
  end
end
