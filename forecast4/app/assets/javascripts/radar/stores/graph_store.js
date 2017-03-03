var GraphStore = new EventEmitter();

GraphStore.visibility = [true, false, false, false];
GraphStore.invoices = [];

GraphStore.dispatchToken = MainDispatcher.register(function(payload) {
  var action = payload.actionType;
  switch(action) {
  case 'RENDER_GRAPH':
    GraphStore.emit('change_with_months');
    break;
  case 'GET_SERIES_VISIBILITY':
    GraphStore.visibility = payload.series;
    break;
  default:
  }
});

  GraphStore.new_series = function(collection, array) {
    collection.forEach(function(payabl, index) {
      array.push({y: 0});
      payabl.forEach(function(inner_val, inner_index) {
        if (typeof(inner_val) == "object") {
          array[index]["y"] = array[index]["y"] + inner_val.y;
          array[index]["object" + inner_index] = inner_val.object
        }
      })
    })
  }

GraphStore.invoicesAsGraph = function(longDuration) {

  var currentCash = InvoiceStore.cashInTheBank;

  // Groups the invoices per date and at the same time computes the current cash for that period
  // based on the total payables and receivables for that group.
  var invoices = InvoiceStore.invoicesToJSON(longDuration);

  invoices = invoices.sort(function(a, b) {
    return (new Date(a.simpleDate) - new Date(b.simpleDate));
  });

  // Group all transactions first by date
  var normalizedGraphData = _.map(_.groupBy(invoices, 'simpleDate'), function(value, key) {
    var receivables = Object.keys(value).map(function(key) {
      if (value[key].type === 'receivables' && !value[key].projected) {
        var receivable = value[key].amount;
        currentCash = currentCash + receivable
        return {y: receivable, object: value[key]}
      } else {
        return 0;
      }
    })
    //.reduce(function(prev, curr) {
    //  return prev + curr
    //})
    //currentCash = currentCash + receivables;

    var payables = Object.keys(value).map(function(key) {
      if (value[key].type === 'payables' && !value[key].projected) {
        var payable = value[key].amount;
        currentCash = currentCash - (payable * -1)
        return {y: payable, object: value[key]};
      } else {
        return 0;
      }
    })
    //.reduce(function(prev, curr) {
    //  return prev + curr
    //})
    // Return the payable amount to positive so the cash gets deducted properly.
    //currentCash = currentCash - (payables * -1);

    var other_payables = Object.keys(value).map(function(key) {
      if (value[key].type === 'other_payables') {
        var other_payable = value[key].amount;
        currentCash = currentCash - (other_payable * -1);
        return {y: other_payable, object: value[key]}
      } else {
        return 0;
      }
    })

    return {
      date : key,
      cash : currentCash,
      receivables : receivables,
      payables : payables,
      other_payables: other_payables
    }
  });

    var other_temp =[] ;
    var payables_temp = [];
    var receivables_temp = [];
    GraphStore.new_series(_.pluck(normalizedGraphData, 'other_payables'), other_temp);
    GraphStore.new_series(_.pluck(normalizedGraphData, 'payables'), payables_temp);
    GraphStore.new_series(_.pluck(normalizedGraphData, 'receivables'), receivables_temp);



  var series = [{
    name : 'Cash',
    data : _.pluck(normalizedGraphData, 'cash'),
    visible : true,
    type : 'area',
    color : '#0088FF',
    negativeColor : '#FF0000'
  }, {
    name : 'Receivables',
    data : receivables_temp,
    visible : false,
    type : 'line'
  }, {
    name : 'payables',
    data : payables_temp,
    visible : false,
    type : 'line'
  }, {
    name: 'other expenses',
    data: other_temp,
    visible: false,
    type: 'line'
  }]

  var categories = _.pluck(normalizedGraphData, 'date');

  return {
    categories : categories,
    series : series
  }
};
