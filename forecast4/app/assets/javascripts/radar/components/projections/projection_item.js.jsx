var ProjectionItem = React.createClass({

  highlight: function () {
    if(this.props.highlight) { return 'highlight' }
  },

  renderCustomer: function (){
    return (
      <div>
        {CustomerStore.customerNameById(this.props.invoice.debtor_id)}
      </div>
    )
  },

  renderVendor: function (){
    if (this.props.invoice.rule_type == 'other_expenses') {
      return (
      <div>
        {this.props.invoice.other_expenses_name}
      </div>
      )
    } else {
    return (
      <div>
        {VendorStore.vendorNameById(this.props.invoice.vendor_id)}
      </div>
      )
    }
  },

  renderContact: function () {
    if(this.props.type === 'receivables') {
      return this.renderCustomer();
    } else {
      return this.renderVendor();
    }
  },

  render: function() {
    return (
      <tr className={this.highlight()}>
        <td>{this.props.invoice.id}</td>
        <td>{this.renderContact()}</td>
        <td>{RadarUtils.formatCurrency(this.props.invoice.amount)}</td>
        <td>{this.props.invoice.interval}</td>
        <td>{moment(this.props.invoice.initial_date).format('YYYY-MM-DD')}</td>
        <td>{moment(this.props.invoice.due_date).format('YYYY-MM-DD')}</td>
      </tr>
    );
  }

})
