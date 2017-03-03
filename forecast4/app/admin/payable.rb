ActiveAdmin.register Payable do

  actions :all, except: [:edit]

  permit_params :invoice_no,
                :face_value,
                :purchase_order_number,
                :date,
                :due_date,
                :anticipated_pay_date,
                :debtor_id,
                :seller_id,
                :paid_on,
                :invoice_xero_id,
                :invoice_contact_id,
                :reference,
                :xero_type,
                :xero_status,
                :total_tax,
                :sub_total,
                :amount_due,
                :amount_paid,
                :amount_credited,
                :updated_date_utc,
                :currency_code,
                :currency_rate

  menu priority: 6

  filter :invoice_no
  filter :face_value
  filter :seller
  filter :vendor,
         :as => :select,
         :collection => proc { Vendor.all.map(&:id) }

  index do
    id_column
    column :invoice_no
    column :seller
    column('Vendor') do |payable|
      if payable.vendor
        link_to payable.vendor.legal_business_name, admin_vendor_path(payable.vendor)
      else
        "-"
      end
    end
    column :face_value
    column :amount_paid
    column :date
    column :xero_status
    actions
  end

end
