var RulesActions = {

  getRulesList : function(scenario_id, rules_type, sort) {
    var postEndPoint = '/radar/scenarios/' + scenario_id + '/rules?' + rules_type + '=true';
    var postType = 'GET';

    $.ajax({
      url : postEndPoint,
      type : postType,
      success : function(data, status, xhr) {
        if (rules_type == "receivables") {
          MainDispatcher.dispatch({
            actionType : 'REFRESH_PAYABLES_RULES',
            rules : data,
            sort : sort
          });
        } else if (rules_type == 'payables' || rules_type == 'other_payables'){
          MainDispatcher.dispatch({
            actionType : 'REFRESH_INVOICES_RULES',
            rules : data,
            sort : sort
          });
        }
      },
      error : function(xhr, data) {
        window.alert("There's an error with rules loading for this scenario. Please try again later");
      }
    });
  },

  submit : function(scenario_id, state) {
    var postEndPoint = '/radar/scenarios/' + scenario_id + '/rules';
    var postType = 'POST';
    if (state.id) {
      postEndPoint += '/' + state.id;
      postType = 'PUT';
    }

    $.ajax({
      url : postEndPoint,
      type : postType,
      data : {
        cash_flow_rule : {
          amount : state.amount,
          interval : state.interval,
          terms : state.terms,
          initial_date : state.initial_date,
          due_date : state.due_date,
          rule_type : state.rule_type,
          debtor_id : state.debtor_id,
          vendor_id : state.vendor_id,
          is_clone : state.is_clone,
          parent_id : state.parent_id,
          is_hidden : state.is_hidden,
          is_sold : state.is_sold,
          other_expenses_name: state.other_expenses_name,
          reccuring: state.reccuring
        }
      },
      success : function(data, status, xhr) {
        if (postType === 'POST') {
          if (state.rule_type == 'expenses' || state.rule_type == 'other_expenses') {
            MainDispatcher.dispatch({
              actionType : 'ADD_EXPENSES_RULE',
              rule : data
            });
          } else {
            MainDispatcher.dispatch({
              actionType : 'ADD_SALES_RULE',
              rule : data
            });
          }
        } else {
          if (state.rule_type == 'expenses' || state.rule_type == 'other_expenses') {
            MainDispatcher.dispatch({
              actionType : 'UPDATE_EXPENSES_RULE',
              rule : data
            });
          } else {
            MainDispatcher.dispatch({
              actionType : 'UPDATE_SALES_RULE',
              rule : data
            });
          }

        }
        InvoiceStore.emit('change');
      },
      error : function(xhr, data) {
        window.alert("There's an error adding this rule. Please try again later");
      }
    });
  },

  delete : function(scenario_id, props, state) {
    var postType = 'DELETE';
    var postEndPoint = '/radar/scenarios/' + scenario_id + '/rules/' + state.id;

    $.ajax({
      url : postEndPoint,
      type : postType,
      success : function(data, status, xhr) {
        if (state.rule_type == 'expenses' || state.rule_type == 'other_expenses') {
          MainDispatcher.dispatch({
            actionType : 'DELETE_EXPENSE_RULE',
            id : state.id
          });
        } else {
          MainDispatcher.dispatch({
            actionType : 'DELETE_PAYABLE_RULE',
            id : state.id
          });
        }
      },
      error : function(xhr, data) {
        window.alert("There's an error deleting this rule. Please try again later");
      }
    });

  }
};
