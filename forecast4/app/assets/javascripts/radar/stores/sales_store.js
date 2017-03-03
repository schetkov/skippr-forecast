var SalesStore = new EventEmitter();

SalesStore.updateStores = function() {
  SalesStore.emit('change');
  InvoiceStore.emit('change');
}

SalesStore.dispatchToken = MainDispatcher.register(function(payload) {
  var action = payload.actionType;
  switch(action) {
  case 'SHOW_SALES_RULE_FORM':
    SalesStore.emit('show_form', payload.rule);
    break;
  case 'CLOSE_FORM':
    SalesStore.emit('close_form');
    break;
  case 'FILTER_RULES':
    SalesStore.emit('filter', payload.ruleId);
    break;
  case 'ADD_SALES_RULE':
    SalesStore.addRule(payload.rule);
    GraphStore.emit('change_with_months');
    break;
  case 'UPDATE_SALES_RULE':
    SalesStore.updateRule(payload.id, payload.rule);
    GraphStore.emit('change_with_months');
    break;
  case 'DELETE_PAYABLE_RULE':
    SalesStore.deleteRule(payload.id);
    GraphStore.emit('change_with_months');
    break;
  case 'REFRESH_PAYABLES_RULES':
    SalesStore.refresh_rules(payload.rules, payload.sort);
    GraphStore.emit('change_with_months');
    break;
  default:
  }
});

SalesStore.rules = []

SalesStore.clear_rules = function() {
  SalesStore.rules = [];
  SalesStore.updateStores();
};

SalesStore.rules_without_clones = function() {
  originals = [];
  SalesStore.rules.forEach(function (no_clone){
    if (!no_clone.is_clone) {originals.push(no_clone)}
  })
  return originals
}

SalesStore.refresh_rules = function(rules, sort) {
  SalesStore.rules = [];
  switch (sort) {
  case "all_invoices":
    SalesStore.rules = rules;
    break;
  case "rules_invoices":
    SalesStore.rules = rules;
    break;
  case "overdue_invoices":
    SalesStore.rules = [];
    break;
  case "outstanding_invoices":
    SalesStore.rules = [];
    break;
  default:
    SalesStore.rules = rules;
  }
  SalesStore.updateStores();
  ScenarioStore.emit('change');

};

SalesStore.addRule = function(rule) {
  rule.forEach(function(item) {
    SalesStore.rules.push(item);
  })
  SalesStore.updateStores();
  SalesStore.emit('close_form');
};
  
SalesStore.updateRule = function(id, rule) {
  for (var i = 0; i < 4; i++) {
    if (undefined != rule[i]) {
      pos = SalesStore.rules.map(function(e) {
        return e.id;
      }).indexOf(rule[i].id);
      SalesStore.rules.splice(pos, 1, rule[i]);
    } else {
      break;
    }
  };
  SalesStore.updateStores();
  SalesStore.emit('close_form');
};

SalesStore.deleteRule = function(id) {
var index = -1;
  for (var i=0; i < SalesStore.rules.length; i++) {
    if ( SalesStore.rules[i].id == id) {
        index = i;
        break;
    }
} 
  SalesStore.rules.splice(index, 4);
  SalesStore.updateStores();
};

SalesStore.totalRules = function() {
  rules = SalesStore.rules;

  total = [];

  rules.forEach(function(rule) {
    SalesStore.rulesAsInvoices(rule.id).forEach(function(rule_item) {
      total.push(rule_item);
    });
  });

  return total;
};

SalesStore.rulesAsInvoices = function(ruleId) {
  var invoices = [];

  var rules = SalesStore.rules;

  if (ruleId) {
    rules = _.filter(rules, function(r) {
      return r.id === ruleId
    })
  }

  rules.forEach(function(rule) {
    var amount = parseFloat(rule.amount_due);
    var interval = parseInt(rule.interval);
    var terms = parseInt(rule.terms);

    var counter = 1;

    invoices.push({
      id : 'SAL' + rule.id,
      amount : rule.amount,
      counter : counter,
      debtor_id : rule.debtor_id,
      initial_sale_date : moment(rule.due_date).format("YYYY-MM-DD"),
      due_date : moment(rule.due_date).add(terms, 'days').format("YYYY-MM-DD"),
      simpleDate : moment(rule.due_date).add(terms, 'days'),
      interval : rule.interval,
      terms : rule.terms,
      rule_id : rule.id
    });

    if (rule.interval > 1) {
      saleDate = moment(rule.due_date);
      targetDate = saleDate.clone();

      for ( counter = 2; counter <= 4; counter += 1) {
        saleDate = saleDate.add(interval, 'days');
        targetDate = saleDate.clone();
        targetDate = targetDate.add(terms, 'days');

        invoices.push({
          id : 'SAL' + rule.id + '_' + counter,
          amount : rule.amount,
          counter : counter,
          debtor_id : rule.debtor_id,
          initial_sale_date : saleDate.format("YYYY-MM-DD"),
          due_date : targetDate.format("YYYY-MM-DD"),
          simpleDate : targetDate,
          interval : rule.interval,
          terms : rule.terms,
          rule_id : rule.id
        });
      };
    }
  });

  invoices = invoices.sort(function(a, b) {
    lhs = a.simpleDate;
    rhs = b.simpleDate;
    return lhs > rhs ? 1 : lhs < rhs ? -1 : 0;
  });

  return invoices;
}
