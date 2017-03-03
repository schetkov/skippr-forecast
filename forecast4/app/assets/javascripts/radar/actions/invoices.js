var InvoicesActions = {

  getInvoices : function(scenario_id, sort) {
    var postEndPoint = '/radar/invoices/' + scenario_id;
    var postType = 'GET';

    $.ajax({
      url : postEndPoint,
      type : postType,
      success : function(data, status, xhr) {
        MainDispatcher.dispatch({
          actionType : 'REFRESH_INVOICES',
          invoices : data,
          sort : sort
        });
      },
      error : function(xhr, data) {
        window.alert("There's an error with invoices loading for this scenario. Please try again later");
      }
    });
  },

  getPayables : function(scenario_id, sort) {
    var postEndPoint = '/radar/payables/' + scenario_id;
    var postType = 'GET';

    $.ajax({
      url : postEndPoint,
      type : postType,
      success : function(data, status, xhr) {
        MainDispatcher.dispatch({
          actionType : 'REFRESH_PAYABLES',
          payables : data,
          sort : sort
        });
      },
      error : function(xhr, data) {
        window.alert("There's an error with payables loading for this scenario. Please try again later");
      }
    });
  },

  updateInvoices : function(scenario_id, state) {
    var postEndPoint = '/radar/scenarios/' + scenario_id + '/financials/invoices';
    var postType = 'PUT';

    $.ajax({
      url : postEndPoint,
      type : postType,
      data : {
        scenario_invoice : {
          invoice_id : state.id,
          due_date : state.due_date,
          anticipated_pay_date : state.anticipated_pay_date,
          is_sold : state.is_sold,
          is_hidden : state.is_hidden
        }
      },
      success : function(data, status, xhr) {
      },
      error : function(xhr, data) {
        window.alert("There's an error updating this invoice. Please try again later");
      }
    });
  },

  updatePayables : function(scenario_id, state) {
    var postEndPoint = '/radar/scenarios/' + scenario_id + '/financials/payables';
    var postType = 'PUT';

    $.ajax({
      url : postEndPoint,
      type : postType,
      data : {
        scenario_payable : {
          payable_id : state.id,
          date : state.initial_date,
          vendor_id : state.debtor_id,
          due_date : state.due_date,
          anticipated_pay_date : state.anticipated_pay_date,
          is_sold : state.is_sold,
          is_hidden : state.is_hidden
        }
      },
      success : function(data, status, xhr) {
      },
      error : function(xhr, data) {
        window.alert("There's an error updating this payable. Please try again later");
      }
    });
  },

  deleteInvoice : function(scenario_id, props, state) {
    var postType = 'DELETE';
    var postEndPoint = '/radar/invoices/' + state.id;

    $.ajax({
      url : postEndPoint,
      type : postType,
      success : function(data, status, xhr) {
        MainDispatcher.dispatch({
          actionType : 'DELETE_INVOICE',
          index : props.index
        });
      },
      error : function(xhr, data) {
        window.alert("There's an error deleting this invoice. Please try again later");
      }
    });
  },

  deletePayable : function(scenario_id, props, state) {
    var postType = 'DELETE';
    var postEndPoint = '/radar/payables/' + state.id;

    $.ajax({
      url : postEndPoint,
      type : postType,
      success : function(data, status, xhr) {
        MainDispatcher.dispatch({
          actionType : 'DELETE_PAYABLE',
          index : props.index
        });
      },
      error : function(xhr, data) {
        window.alert("There's an error deleting this payable. Please try again later");
      }
    });
  }
}