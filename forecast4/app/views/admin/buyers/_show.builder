context.instance_eval do
  attributes_table do
    row :id
    row :name
    row :email
    row("Status") do |buyer|
      buyer.workflow_state.capitalize
    end
    row :company do |buyer|
      buyer.user.company_name
    end
    row :created_at
    row :updated_at
  end

  render "admin/bank_details/index",
    bank_details: buyer.buyer_company.bank_details,
    context: self if buyer.buyer_company.bank_details

  render "admin/accountant/show",
    accountant: buyer.buyer_company.accountant,
    context: self if buyer.buyer_company.accountant

  render "admin/afsl/show",
    afsl: buyer.afsl, context: self if buyer.afsl

  render "admin/trades/index",
    trades: buyer.trades, context: self if buyer.trades
end
