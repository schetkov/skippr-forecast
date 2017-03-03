var InvoicesIndex = React.createClass({

  getInitialState: function () {
    return ({
      lastUpdated: new Date()
    });
  },

  componentWillMount: function () {
    InvoiceStore.on('change', this._onChange);
  },

  componentWillUnmount: function () {
    InvoiceStore.off('change', this._onChange);
  },

  _onChange: function () {
    this.setState({lastUpdated: new Date()});
  },

  renderHeaders: function () {
    if (this.props.type === 'payables') {
      return (
        <tr>
          <th>Vendor</th>
          <th>Face Value</th>
          <th>Invoice Received</th>
          <th>Due Date</th>
          <th>Anticipated Pay Date</th>
          <th>Show / Hide</th>
          <th>Delete</th>
        </tr>
      );
    } else {
      return (
        <tr>
          <th>Debtor</th>
          <th>Face Value</th>
          <th>Issued At</th>
          <th>Due Date</th>
          <th>Anticipated Pay Date</th>
          <th>Action</th>
          <th>Show / Hide</th>
          <th>Delete</th>
        </tr>
      );
    }
  },

  invoices: function () {
    if (this.props.type === 'receivables') {
      return InvoiceStore.invoicesWithProjection();
    } else {
      return InvoiceStore.payablesWithProjection();
    }
  },

  renderInvoices: function () {
    if (this.props.type === 'receivables') {
      return (
        InvoiceStore.invoicesWithProjection().map(function (invoice, i) {
          return <ReceivableInvoiceItem invoice={invoice} key={invoice.key ? invoice.key : invoice.id} index={i} type={this.props.type} scenario={ScenarioStore.selected_scenario}/>
        }, this)
      )

    } else {
      return (
        InvoiceStore.payablesWithProjection().map(function (invoice, i) {
          return <PayableInvoiceItem invoice={invoice} key={invoice.key ? invoice.key : invoice.id} index={i} type={this.props.type} scenario={ScenarioStore.selected_scenario}/>
        }, this)
      )
    }
  },

  render: function () {
    return (
      <table className='table table-striped table-hover'>
        <thead>
          { this.renderHeaders() }
        </thead>
        <tbody>
        { this.renderInvoices() }
        </tbody>
      </table>
    )
  }

});
