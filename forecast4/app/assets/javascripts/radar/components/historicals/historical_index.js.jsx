var HistoricalIndex = React.createClass({
  renderHeaders: function () {
    if ( this.props.type === 'sales_forecast' ) {
      return (
        <tr>
          <th>Customer</th>
          <th>Face Value</th>
          <th>Issued At</th>
          <th>Due Date</th>
          <th>Create rule</th>
        </tr>
      );
    } else {
      return (
        <tr>
          <th>Vendor</th>
          <th>Face Value</th>
          <th>Issued At</th>
          <th>Due Date</th>
          <th>Create rule</th>
        </tr>
      );
    }
  },

  invoices: function () {
    if (this.props.type === 'sales') {
      return InvoiceStore.invoices;
    } else if (this.props.type === 'expense') {
      return InvoiceStore.payables;
    }
  },

  render: function () {
    return (
      <table className='table table-condensed table-striped table-hover'>
        <thead>
          { this.renderHeaders() }
        </thead>
        <tbody>
        { this.invoices().map(function (invoice, i) {
            return <HistoricalItem invoice={invoice} key={invoice.id} index={i} type={this.props.type} />
          }, this)
        }
        </tbody>
      </table>
    )
  }
});
