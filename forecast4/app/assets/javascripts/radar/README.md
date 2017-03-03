## CashFlow Tool

A react application on top of rails. Everything is in the app/assets/javascripts/radar

- Imports data from Xero. This is being done by the main application already and both applications just share data. See: app/models/Invoice.rb
- There are two types of invoice records. Receivables and Payables. From Xero, their records are separated as ACCREC/ACCPAY. There are existing scopes already for this to separate the queries.
- Cash flow scenario and cash flow rules (app/models/cash_flow_scenario.rb and app/models/cash_flow_rules.rb)

### Requirements/Dependencies

- react.js
- react-rails
- flux
- highcharts.js
- See app/assets/javascripts/radar_application.js._ for more 3rd party dependencies

The app is written using traditional react + flux architecture to achieve a dynamic experience.

a) Graphs updating when a customer decides to sell the invoice.
b) Adding cash flow rules automatically updates dependent components and graphs

- components

### Installation

The current installation just uses Rails asset pipeline. No need for npm. Although ideally we might need to consider browserify, webpack as a better solution. But you might need to discuss it with the core developers as that affects the deployment. It will add additional dependencies to the app.

### Things to do

There are still a couple of pending items.

- Mostly related to cash flow expense projection.
- Cash flow scenario. At the moment, it only supports one scenario per customer.
- Ability to change the projected date. This can be done just by setting the invoice.due_date or invoice.anticipated_pay_date of an invoice component. See invoices/item.js.jsx (Add a feature where it replaces the due date with an inline date picker then do a setState({anticipated_pay_date: newDate}, -> ()). You also need to update the invoice record in the InvoiceStore (stores/invoice_store.js). Changing the projected date doesn't need to be persisted.

### Things to watch out

- Invoices are loaded as json properties. Please see app/views/radar/invoices/index.haml (This reduces the need to do ajax based calls to load the data)
- Projected invoices are dynamically generated. See: app/assets/javascripts/radar/stores

### For more info

jason@mashupgarage.com
