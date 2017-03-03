InvoiceExchange::Application.routes.draw do
  ActiveAdmin.routes(self)

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]

  resources :users, controller: "clearance/users", only: [] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"

  resources :users,
    controller: 'users',
    only: [:create, :update]

  resource :session,
    controller: 'sessions',
    only: [:new, :create, :destroy]

  resource :user_signup, only: [:create], as: :user_signups

  resource :seller_registration, only: [:create]

  resource :business_registration, only: [:create], module: "registration"
  resource :customer_registration, only: [:create], module: "registration"
  resource :terms_registration, only: [:create], module: "registration"
  get "/wizard/business" => "registration/business_registrations#new", as: :business_wizard
  get "/wizard/xero" => "xero#new", as: :new_xero
  get "/wizard/new_xero" => "xero#new_cash_flow_user", as: :new_cash_flow_user_xero
  get "/wizard/customers" => "registration/customer_registrations#new", as: :customer_wizard
  get "/wizard/terms" => "registration/terms_registrations#new", as: :terms_wizard

  resource :registration do
    resource :master_services_agreement,
      only: [:show, :update], module: :registration
  end

  resources :sellers, only: [:index, :show] do
    resources :attachments, only: [:create], module: "sellers"
    resource :financial, only: [:update]
  end

  resources :trades
  resources :debtors
  resources :invoices, only: [:index, :show, :destroy]

  resources :debtors do
    resources :attachments, only: [:create, :create], module: "debtors"
    resources :invoices, only: [:new, :create]
  end

  resources :buyers, only: [:show, :update]

  resources :seller_companies, only: [:update]
  resources :buyer_companies, only: [:update]

  get '/settings' => 'users#edit', as: :settings

  resource :dashboard,
    only: [:show],
    as: :seller_dashboard,
    module: "sellers"
      resource :dealboard,
        only: [:show],
        as: :buyer_dealboard,
        module: "buyers"

  get "/faq" => "pages#show", id: 'faq', as: :faq

  resource :session,
    controller: 'sessions',
    only: [:new, :create, :destroy]

  resources :users,
    controller: 'users',
    only: [:new, :create, :update]


  namespace :radar do
    resources :invoices, only: [:index]
    get 'invoices/:scenario_id' => 'invoices#invoices'
    get 'payables/:scenario_id' => 'invoices#payables'
    delete 'invoices/:invoice_id' => 'invoices#destroy_invoice'
    delete 'payables/:payable_id' => 'invoices#destroy_payable'
    resources :scenarios do
      resources :rules
      put 'financials/invoices' => 'financials#invoices'
      put 'financials/payables' => 'financials#payables'
    end
  end

  get "/signed_up" => "users#signed_up", as: :signed_up

  get "/xero_session" => "xero_sessions#authorize_xero", as: :xero_session
  get "/xero_session/new" => "xero_sessions#new", as: :new_xero_session

  resource :retry_registration, only: [:update]
  resources :invoice_approvals, only: [:update], as: :invoice_approvals

  resource :how_it_works, only: [:show]

  ### Admin Routes

  namespace :custom_admin do
    get "", to: "dashboard#index", as: "/"

    resources :sellers do
      get "/invoices" => "sellers/invoices#index", as: :invoices
    end
    resources :buyers
    resources :trades, only: [:index, :show]
    resources :debtors, only: [:index, :show]
    resources :invoices, only: [:index, :show] do
      resources :ratings, only: [:new, :create]
    end
    resources :mandates, only: [:new, :create]
    resources :fund_statements, only: [:create]
    get "/custom_admin/deposits/new" => "fund_statements#new", as: :new_deposit
    post "/custom_admin/debtor_approvals" => "debtor_approvals#create", as: :debtor_approvals
    post "/custom_admin/invoice_approvals" => "invoice_approvals#create", as: :invoice_approvals
    post "/custom_admin/trade_funded" => "trade_funded#create", as: :trade_funded
    post "/custom_admin/invoice_repayments" => "invoice_repayments#create", as: :invoice_repayments
    post "/custom_admin/allocate_funds" => "allocate_funds#create", as: :allocate_funds
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
    namespace :admin do
      resources :approve_companies, only: [:update]
      resources :approve_sellers, only: [:update]
      resources :approve_buyers, only: [:update]
      resources :approve_debtors, only: [:update]
      resources :approve_invoices, only: [:update]
      resources :sellers do
        resources :credit_reports, only: [:create, :destroy]
      end

      patch '/debtor/credit_reports/:id' => 'debtor_credit_reports#update',
        as: :debtor_credit_reports
      delete '/debtors/:debtor_id/credit_reports/:id' => 'debtor_credit_reports#destroy_credit_report',
        as: :delete_debtor_credit_report
      delete '/debtors/:debtor_id/sales_agreements/:id' => 'debtor_credit_reports#destroy_sales_agreement',
        as: :delete_debtor_sales_agreement
      post 'invoice/payment_status_email/:id' => 'send_invoice_emails#create', as: :send_invoice_emails

      resources :custom_invoices, only: [:create, :update, :destroy]

      patch '/invoice/ppsr/:id' => 'invoice_ppsr#update', as: :invoice_ppsr
      delete '/invoices/:invoice_id/ppsr/:id' => 'invoice_ppsr#destroy',
        as: :delete_invoice_ppsr

      delete '/invoices/:invoice_id/notice_of_assignments/:id' => 'notice_of_assignments#destroy',
        as: :invoice_notice_of_assignment
    end
  end

  root to: redirect("/sign_in"), as: :signed_out_root
  # root to: redirect("http://www.skippr.com.au"), as: :signed_out_root
end
