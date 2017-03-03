/*
  Placeholder component until we've changed the items below as ajax request (or we may not have to).
*/
var Radar = React.createClass({
  componentDidMount: function () {
    InvoiceStore.invoices = this.props.receivables;
    InvoiceStore.payables = this.props.payables;
    InvoiceStore.invoices_outstanding = this.props.invoices_outstanding;
    InvoiceStore.payables_outstanding = this.props.payables_outstanding;
    CustomerStore.customers = this.props.customers;
    VendorStore.vendors = this.props.vendors;
    ScenarioStore.scenarios = this.props.scenarios;
    ScenarioStore.selected_scenario = ScenarioStore.default_scenario().id;
  },

  render: function () {
    return(<div/>)
  }
});

var RadarUtils = {};

RadarUtils.customerNameById = function (id) {
  var customer = CustomerStore.findById(id)
  if(customer) {
    return customer.legal_business_name
  }
}

RadarUtils.formatCurrency = function (amount) {
  return accounting.formatMoney(amount);
}

var confirmDelete =  function(message, options) {
  var cleanup, component, props, wrapper;
  if (options == null) {
    options = {};
  }
  props = $.extend({
    message: message
  }, options);
  wrapper = document.body.appendChild(document.createElement('div'));
  component = ReactDOM.render(<Confirm {...props}/>, wrapper);
  cleanup = function() {
    ReactDOM.unmountComponentAtNode(wrapper);
    return setTimeout(function() {
      return wrapper.remove();
    });
  };
  return component.promise.always(cleanup).promise();
};