var HistoricalItem = React.createClass({

  createSalesForecastRule: function(e) {
    MainDispatcher.dispatch({
      actionType: 'SHOW_SALES_RULE_FORM',
      rule: {
        amount: this.props.invoice.face_value,
        debtor_id: this.props.invoice.debtor_id,
        initial_date: moment().format("YYYY-MM-DD"),
        rule_type: 'sales'
      }
    });
  },

  createExpenceForecastRule: function(e) {
    MainDispatcher.dispatch({
      actionType: 'SHOW_EXPENSE_RULE_FORM',
      rule: {
        amount: this.props.invoice.face_value,
        vendor_id: this.props.invoice.vendor_id,
        initial_date: moment().format("YYYY-MM-DD"),
        rule_type: 'expenses'
      }
    });
  },

  renderSalesForecast: function() {
    return (
      <tr>
        <td>{CustomerStore.customerNameById(this.props.invoice.debtor_id)}</td>
        <td>{RadarUtils.formatCurrency(this.props.invoice.face_value)}</td>
        <td>{this.props.invoice.date}</td>
        <td>{this.props.invoice.due_date}</td>
        <td>
          <button className='btn btn-primary' onClick={this.createSalesForecastRule}>Create rule</button>
        </td>
      </tr>
    );
  },

  renderExpenceForecast: function() {
    return (
      <tr>
        <td>{VendorStore.vendorNameById(this.props.invoice.vendor_id)}</td>
        <td>{RadarUtils.formatCurrency(this.props.invoice.face_value)}</td>
        <td>{this.props.invoice.date}</td>
        <td>{this.props.invoice.due_date}</td>
        <td>
          <button className='btn btn-primary' onClick={this.createExpenceForecastRule}>Create rule</button>
        </td>
      </tr>
    );
  },

  render: function() {
    if (this.props.type === 'sales') {
      return this.renderSalesForecast();
    } else if (this.props.type === 'expense') {
      return this.renderExpenceForecast();
    }
  }

});