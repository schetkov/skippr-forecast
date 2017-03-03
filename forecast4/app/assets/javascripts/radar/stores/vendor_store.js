var VendorStore = new EventEmitter();

VendorStore.vendors = [];

VendorStore.findById = function (id) {
  return _.find(VendorStore.vendors, function (c) {
    return c.id === id
  });
}

VendorStore.vendorNameById = function (id) {
  var vendor = VendorStore.findById(id)
  if(vendor) {
    return vendor.legal_business_name
  }
}

VendorStore.default_customer = function () {
  return _.first(VendorStore.vendors);
};

