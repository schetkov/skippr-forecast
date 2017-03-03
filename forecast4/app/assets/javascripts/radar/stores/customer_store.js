var CustomerStore = new EventEmitter();

CustomerStore.customers = [];

CustomerStore.findById = function (id) {
  return _.find(CustomerStore.customers, function (c) {
    return c.id === id
  });
}

CustomerStore.customerNameById = function (id) {
  var customer = CustomerStore.findById(id)
  if(customer) {
    return customer.legal_business_name
  }
}

CustomerStore.default_customer = function () {
  return _.first(CustomerStore.customers);
};

