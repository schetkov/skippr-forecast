var ExpenseStore = new EventEmitter();

ExpenseStore.updateStores = function() {
  ExpenseStore.emit('change');
  InvoiceStore.emit('change');
}

ExpenseStore.dispatchToken = MainDispatcher.register(function(payload) {
  var action = payload.actionType;
  switch(action) {
  case 'SHOW_EXPENSE_RULE_FORM':
    ExpenseStore.emit('show_form', payload.rule);
    break;
  case 'CLOSE_FORM':
    ExpenseStore.emit('close_form');
    break;
  case 'SHOW_EXPENSES_RULES':
    ExpenseStore.updateStores();
    break;
  case 'FILTER_RULES':
    ExpenseStore.emit('filter', payload.ruleId);
    break;
  case 'ADD_EXPENSES_RULE':
    ExpenseStore.addRule(payload.rule);
    GraphStore.emit('change_with_months');
    break;
  case 'UPDATE_EXPENSES_RULE':
    ExpenseStore.updateRule(payload.index, payload.rule);
    GraphStore.emit('change_with_months');
    break;
  case 'DELETE_EXPENSE_RULE':
    ExpenseStore.deleteRule(payload.id);
    GraphStore.emit('change_with_months');
    break;
  case 'REFRESH_INVOICES_RULES':
    ExpenseStore.refresh_rules(payload.rules, payload.sort);
    GraphStore.emit('change_with_months');
    break;
  default:
  }
});

ExpenseStore.rules = []

ExpenseStore.clear_rules = function() {
  ExpenseStore.rules = [];
  ExpenseStore.updateStores();
};

ExpenseStore.regular_rules = function() {
  regular_rules_arr = [];
  ExpenseStore.rules.forEach(function(regular_rule) {
    if (regular_rule.rule_type != "other_expenses") {
      regular_rules_arr.push(regular_rule);
    }
  })
  return regular_rules_arr
}

ExpenseStore.regular_rules_without_clones = function() {
  originals = [];
  ExpenseStore.regular_rules().forEach(function (no_clone){
    if (!no_clone.is_clone) {originals.push(no_clone)}
  })
  return originals
}

ExpenseStore.other_rules = function() {
  other_rules_arr = [];
  ExpenseStore.rules.forEach( function(other_rule) {
    if (other_rule.rule_type == "other_expenses") {other_rules_arr.push(other_rule)};
  })
  return other_rules_arr;
}

ExpenseStore.other_rules_without_clones = function() {
  originals = [];
  ExpenseStore.other_rules().forEach(function (no_clone){
    if (!no_clone.is_clone) {originals.push(no_clone)}
  })
  return originals
}

ExpenseStore.refresh_rules = function(rules, sort) {
  ExpenseStore.rules = [];

  switch (sort) {
  case "all_invoices":
    ExpenseStore.rules = rules;
    break;
  case  "rules_invoices":
    ExpenseStore.rules = rules;
    break;
  case "overdue_invoices":
    ExpenseStore.rules = [];
    break;
  case "outstanding_invoices":
    ExpenseStore.rules = [];
    break;
  default:
    ExpenseStore.rules = rules;
  }

  ExpenseStore.updateStores();
  ScenarioStore.emit('change');

};

ExpenseStore.addRule = function(rule) {
  rule.forEach(function(item) {
    ExpenseStore.rules.push(item);
  });
  ExpenseStore.updateStores();
  ExpenseStore.emit('close_form');
};

ExpenseStore.getPosition = function(rule){
  pos = ExpenseStore.rules.map(function(e) {
    return e.id;
  }).indexOf(rule.id);
  return pos;
}

ExpenseStore.updateRule = function(index, rule) {
  if (rule[0].rule_type != 'other_expenses') {
    for (var i = 0; i < 4; i++) {
      if (undefined != rule[i]) {
        pos = ExpenseStore.rules.map(function(e) {
          return e.id;
        }).indexOf(rule[i].id);
        ExpenseStore.rules.splice(pos, 1, rule[i]);
      } else {
        break;
      }
    };
  } else {
    var clones = []
    ExpenseStore.rules.forEach(function(clone) {
      if (clone.is_clone && clone.parent_id == rule[0].id) {
        clones.push(clone);
      }
    })
    if (rule[0].reccuring && clones.length == 0){
      pos = ExpenseStore.getPosition(rule[0])
      ExpenseStore.rules.splice(pos, 1);
      for (var i = 0; i < 4; i++){
        if (undefined != rule[i]) {
          ExpenseStore.rules.splice(pos+i,0,rule[i]);
        }
      }
    } else if (rule[0].reccuring && clones.length != 0) {
      clones.splice(0, 0, rule[0]);
      for (var i = 0; i < 4; i++) {
        if (undefined != rule[i]) {
          ExpenseStore.rules.splice(ExpenseStore.getPosition(clones[i]),1, rule[i])
        }
      }
    } else if (!rule[0].reccuring && clones.length == 0) {
      ExpenseStore.rules.splice(ExpenseStore.getPosition(rule[0]), 1, rule[0]);
    } else if (!rule[0].reccuring && clones.length != 0){
      ExpenseStore.rules.splice(ExpenseStore.getPosition(rule[0]), 1, rule[0]);
      clones.forEach(function(clone){
        if (undefined != rule[i]) {
          ExpenseStore.rules.splice(ExpenseStore.getPosition(clone), 1);
        }
      })
    }
  }
  ExpenseStore.updateStores();
  ExpenseStore.emit('close_form');
};

ExpenseStore.deleteRule = function(id) {
  var clones = []
    ExpenseStore.other_rules().forEach(function(clone) {
      if (clone.is_clone && clone.parent_id == id) {
        clones.push(clone);
      }
    })
  var index = -1;
  for (var i=0; i<ExpenseStore.rules.length; i++) {
    if ( ExpenseStore.rules[i].id == id) {
        var index = i;
        break;
    }
  }
  if (ExpenseStore.rules[index].rule_type == 'other_expenses') {
    ExpenseStore.rules.splice(index, 1);
    clones.forEach(function(clone){
      ExpenseStore.rules.splice(ExpenseStore.getPosition(clone), 1)
    })
  } else {
    ExpenseStore.rules.splice(index, 4);
  }
  
  ExpenseStore.updateStores();
};

ExpenseStore.totalRules = function() {
  rules = ExpenseStore.rules;

  total = [];

  rules.forEach(function(rule) {
    ExpenseStore.rulesAsPayables(rule.id).forEach(function(rule_item) {
      total.push(rule_item);
    });
  });

  return total;
};

ExpenseStore.rulesAsPayables = function(ruleId) {
  var invoices = [];

  var rules = ExpenseStore.rules;

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
      id : 'EXP' + rule.id,
      amount : rule.amount,
      counter : counter,
      vendor_id : rule.vendor_id,
      initial_sale_date : moment(rule.due_date).format("YYYY-MM-DD"),
      due_date : moment(rule.due_date).add(terms, 'days').format("YYYY-MM-DD"),
      simpleDate : moment(rule.due_date).add(terms, 'days'),
      interval : rule.interval,
      terms : rule.terms,
      rule_id : rule.id
    });

    if (rule.interval > 1) {
      // Add another 3 more weeks worth of payables
      saleDate = moment(rule.due_date);
      targetDate = saleDate.clone();

      for ( counter = 2; counter <= 4; counter += 1) {
        saleDate = saleDate.add(interval, 'days');
        targetDate = saleDate.clone();
        targetDate = targetDate.add(terms, 'days');

        invoices.push({
          id : 'EXP' + rule.id + '_' + counter,
          amount : rule.amount,
          counter : counter,
          vendor_id : rule.vendor_id,
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
