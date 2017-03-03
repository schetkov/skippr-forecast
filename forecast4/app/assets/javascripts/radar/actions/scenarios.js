var ScenariosActions = {

  refreshScenario : function(scenario_id) {
    RulesActions.getRulesList(scenario_id, 'receivables', InvoiceStore.selected_filter);
    RulesActions.getRulesList(scenario_id, 'payables', InvoiceStore.selected_filter);
    InvoicesActions.getInvoices(scenario_id, InvoiceStore.selected_filter);
    InvoicesActions.getPayables(scenario_id, InvoiceStore.selected_filter);
  },

  create : function(state) {
    var postEndPoint = '/radar/scenarios'
    var postType = 'POST';

    $.ajax({
      url : postEndPoint,
      type : postType,
      data : {
        scenario : {
          title : state.title,
        }
      },
      success : function(data, status, xhr) {
        MainDispatcher.dispatch({
          actionType : 'CREATE_SCENARIO',
          scenario : data
        });
      },
      error : function(xhr, data) {
        window.alert("There's an error adding this scenario. Please try again later");
      }
    });
  },

  update : function(scenario_id, state) {
    var postEndPoint = '/radar/scenarios/' + scenario_id;
    var postType = 'PATCH';

    $.ajax({
      url : postEndPoint,
      type : postType,
      data : {
        scenario : {
          title : state.title,
        }
      },
      success : function(data, status, xhr) {
        MainDispatcher.dispatch({
          actionType : 'UPDATE_SCENARIO',
          scenario : data
        });
      },
      error : function(xhr, data) {
        window.alert("There's an error updating this scenario. Please try again later");
      }
    });
  },

  delete : function(scenario_id, state) {
    var postEndPoint = '/radar/scenarios/' + scenario_id;
    var postType = 'DELETE';

    $.ajax({
      url : postEndPoint,
      type : postType,
      success : function(data, status, xhr) {
        MainDispatcher.dispatch({
          actionType : 'DELETE_SCENARIO'
        });
      },
      error : function(xhr, data) {
        window.alert("There's an error deleting this scenario. Please try again later");
      }
    });
  }
}