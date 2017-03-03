ActiveAdmin.register Invoice do
  form partial: 'form'

  permit_params :invoice_no,
                :face_value,
                :purchase_order_number,
                :discounts_offered,
                :date,
                :due_date,
                :anticipated_pay_date,
                :service_rendered,
                :customer_satisfied,
                :payment_to_be_sent,
                :admin_funding_status_notes,
                :payment_period,
                :payment_period_paid,
                :merchandise_shipped_on,
                :merchandise_arrived_on,
                :shipping_company_url,
                :tracking_code,
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
                :currency_rate,
                :fully_paid_on_date,
                :rating_value,
                :workflow_state,
                :debtor_id,
                :seller_id,
                :file

  menu priority: 6

  filter :invoice_no
  filter :face_value
  filter :seller
  filter :debtor,
         :as => :select,
         :collection => proc { Debtor.all.map(&:id) }
  filter :payment_status,
    :as => :select,
    :collection => ['Outstanding', 'Paid in full', 'Short Paid']

  scope :all
  scope :with_pending_state
  scope :with_selected_state
  scope :with_approved_state

  index do
    id_column
    column :invoice_no
    column :seller
    column('Debtor') do |invoice|
      if invoice.debtor
        link_to invoice.debtor.legal_business_name, admin_debtor_path(invoice.debtor)
      else
        "-"
      end
    end
    column :face_value
    column :amount_paid
    column :amount_due
    column :amount_credited
    column :date
    column :paid_on
    column("Rating") do |invoice|
      invoice.rating_value
    end
    column('Status') do |invoice|
      if invoice.workflow_state == "selected"
        button_to 'Approve Invoice', admin_approve_invoice_path(invoice),
          method: :patch
      else
        invoice.workflow_state.capitalize
      end
    end
    column :xero_status
    column :actions do |invoice|
      raw( %(#{link_to "View", [:admin, invoice]}
             #{link_to "Delete", [:admin, invoice], method: :delete unless invoice.trade && invoice.trade.confirmed_at }
             #{(link_to"Edit", [:edit, :admin, invoice]) }) )
    end
  end

  show title: :id do
    render "show", context: self
  end

  csv do
    column(:invoice_no)
    column("Invoice Date") { |invoice| invoice.date.strftime("%d/%m/%y") }
    column("Due Date") { |invoice| invoice.due_date.strftime("%d/%m/%y") }
    column("Anticipated Pay Date") { |invoice| invoice.anticipated_pay_date.strftime("%d/%m/%y")  }
    column(:face_value) { |invoice| invoice.face_value.to_i }
  end
end
