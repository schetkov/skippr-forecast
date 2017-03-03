var InvoiceStore = new EventEmitter()

InvoiceStore.cashInTheBank = 0;
InvoiceStore.invoices = [];
InvoiceStore.payables = [];

InvoiceStore.updateStores = function() {
  InvoiceStore.emit('change');
  GraphStore.emit('change_with_months');
}

InvoiceStore.dispatchToken = MainDispatcher.register(function(payload) {
  var action = payload.actionType;
  switch(action) {
  case 'RECEIVABLE_ITEM_UPDATE':
    InvoiceStore.updateInvoice(payload.invoice);
    InvoiceStore.updateStores();
    break;
  case 'PAYABLE_ITEM_UPDATE':
    InvoiceStore.updatePayable(payload.invoice);
    InvoiceStore.updateStores();
    break;
  case 'UPDATE_CASH':
    InvoiceStore.cashInTheBank = parseFloat(payload.cash);
    GraphStore.emit('change_with_months');
    break;
  case 'ADD_EXPENSES_RULE':
    MainDispatcher.waitFor([ExpenseStore.dispatchToken]);
    InvoiceStore.updateStores();
    break;
  case 'ADD_SALES_RULE':
    MainDispatcher.waitFor([SalesStore.dispatchToken]);
    InvoiceStore.updateStores();
    break;
  case 'REFRESH_INVOICES':
    InvoiceStore.invoices = InvoiceStore.sortInvoices(payload.invoices, payload.sort);
    InvoiceStore.emit('change');
    GraphStore.emit('change_with_months');
    break;
  case 'REFRESH_PAYABLES':
    InvoiceStore.payables = InvoiceStore.sortInvoices(payload.payables, payload.sort);
    InvoiceStore.emit('change');
    GraphStore.emit('change_with_months');
    break;
  case 'DELETE_INVOICE':
    InvoiceStore.invoices.splice(payload.index, 1);
    InvoiceStore.emit('change');
    GraphStore.emit('change_with_months');
    break;
  case 'DELETE_PAYABLE':
    InvoiceStore.payables.splice(payload.index, 1);
    InvoiceStore.emit('change');
    GraphStore.emit('change_with_months');
    break;
  default:
  }
});

InvoiceStore.selected_filter = 'all_invoices'

InvoiceStore.updateInvoice = function(invoice) {
  index = InvoiceStore.invoices.map(function(x) {
    return x.id;
  }).indexOf(invoice.id);
  InvoiceStore.invoices[index] = invoice;
}

InvoiceStore.updatePayable = function(invoice) {
  index = InvoiceStore.payables.map(function(x) {
    return x.id;
  }).indexOf(invoice.id);
  InvoiceStore.payables[index] = invoice;
}
// Sorting invoices by sort field from payload response var

InvoiceStore.sortInvoices = function(data, sort) {
  var allInvoices = [];
  switch (sort) {
  case "all_invoices":
    allInvoices = _.clone(data);
    break;
  case "rules_invoices":
    all_invoices = [];
    break;
  case "overdue_invoices":
    _.clone(data).forEach(function(invoice) {
      if (invoice.due_date < moment().format('YYYY-MM-DD')) {
        allInvoices.push(invoice);
      }
    });
    break;
  case "outstanding_invoices":
    _.clone(data).forEach(function(invoice) {
      if (invoice.due_date >= moment().format('YYYY-MM-DD')) {
        allInvoices.push(invoice);
      }
    });
    break;
  default:
    allInvoices = _.clone(data);
  };

  return allInvoices;
}

InvoiceStore.invoicesWithProjection = function(sort) {
  allInvoices = _.clone(InvoiceStore.invoices);

  SalesStore.rules.forEach(function(invoice) {
    allInvoices.push({
      id : invoice.id,
      key : 'P' + invoice.id,
      projected : true,
      face_value : invoice.amount,
      amount_due : invoice.amount,
      debtor_id : invoice.debtor_id,
      debtor : '',
      date : invoice.initial_sale_date,
      due_date : invoice.due_date,
      initial_date : invoice.initial_date,
      anticipated_pay_date : invoice.due_date,
      terms : invoice.terms,
      is_sold : invoice.is_sold,
      is_hidden : invoice.is_hidden
    })
  })
  allInvoices = allInvoices.sort(function(a, b) {
    lhs = moment(a.anticipated_pay_date);
    rhs = moment(b.anticipated_pay_date);
    return lhs > rhs ? 1 : lhs < rhs ? -1 : 0;
  });

  return allInvoices;
}

InvoiceStore.payablesWithProjection = function(sort) {
  allInvoices = _.clone(InvoiceStore.payables);

  ExpenseStore.rules.forEach(function(invoice) {
    allInvoices.push({
      id : invoice.id,
      key : 'P' + invoice.id,
      projected : true,
      face_value : invoice.amount,
      amount_due : invoice.amount,
      vendor_id : invoice.vendor_id,
      vendor : '',
      rule_type: invoice.rule_type,
      date : invoice.initial_sale_date,
      due_date : invoice.due_date,
      initial_date : invoice.initial_date,
      anticipated_pay_date : invoice.due_date,
      terms : invoice.terms,
      is_sold : invoice.is_sold,
      is_hidden : invoice.is_hidden,
      other_expenses_name: invoice.other_expenses_name
    })
  })
  allInvoices = allInvoices.sort(function(a, b) {
    lhs = moment(a.anticipated_pay_date);
    rhs = moment(b.anticipated_pay_date);
    return lhs > rhs ? 1 : lhs < rhs ? -1 : 0;
  });
  return allInvoices;
}

InvoiceStore.invoicesToJSON = function(longDuration) {
  var graphData = [];
  var today = moment().set({
    'hour' : 01,
    'minute' : 00
  });

  // Adds all receivables w/ projection
  InvoiceStore.invoicesWithProjection().forEach(function(invoice) {
    if (invoice.is_hidden) {
      return
    }
    var amount = parseFloat(invoice.face_value);
    var targetDate = new Date(invoice.anticipated_pay_date)

    if (invoice.is_sold) {
      targetDate = new Date(invoice.due_date);
    } else if (targetDate < today && InvoiceStore.selected_filter != 'overdue_invoices') {
      return;
    }

    if (targetDate !== 'Invalid date') {
      graphData.push({
        simpleDate : moment(targetDate).format('YYYY-MM-DD').toString(),
        rawDate : targetDate,
        amount : amount,
        type : 'receivables',
        name: CustomerStore.customerNameById(invoice.debtor_id)
      });
    }
  });

  // Adds all payables w/ projection
  InvoiceStore.payablesWithProjection().forEach(function(invoice) {
    if (invoice.is_hidden) {
      return
    }
    var amount = parseFloat(invoice.face_value);
    amount = amount * -1// since payables are outgoing, show them below the horizontal axis
    var targetDate = new Date(invoice.anticipated_pay_date);

    if (invoice.is_sold) {
      targetDate = new Date(invoice.due_date);
    } else if (targetDate < today && InvoiceStore.selected_filter != 'overdue_invoices') {
      return;
    }

    if (targetDate !== 'Invalid date' && invoice.vendor_id != null) {
      graphData.push({
        simpleDate : moment(targetDate).format('YYYY-MM-DD').toString(),
        rawDate : targetDate,
        amount : amount,
        type : 'payables',
        name: VendorStore.vendorNameById(invoice.vendor_id)
      });
    } else if (targetDate !== 'Invalid date' && invoice.vendor_id == null) {
      graphData.push({
        simpleDate : moment(targetDate).format('YYYY-MM-DD').toString(),
        rawDate : targetDate,
        amount : amount,
        type : 'other_payables',
        name: invoice.other_expenses_name
      });
    }
  });

  invoicesSorted = []

  var borderDate = moment().add(6, 'months').format('YYYY-MM-DD');
  if (longDuration == false) {
    borderDate = moment().add(3, 'months').format('YYYY-MM-DD')
  };

  graphData.forEach(function(invoice) {
    if (invoice.simpleDate < borderDate.toString()) {
      invoicesSorted.push(invoice)
    }
  })

  return invoicesSorted;
}
