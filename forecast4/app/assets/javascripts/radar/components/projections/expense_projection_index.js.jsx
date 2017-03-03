var ExpenseProjectionIndex = React.createClass({

  getInitialState: function () {
    return {
      filterByRuleId: null
    }
  },

  componentDidMount: function () {
    ExpenseStore.on('change', this._onChange);
    ExpenseStore.on('filter', this._onFilter);
  },

  componentWillUnmount: function () {
    ExpenseStore.off('change', this._onChange);
    ExpenseStore.off('filter', this._onFilter);
  },

  invoices: function () {
    if (this.props.type == 'other_payables') {
    return ExpenseStore.other_rules();
  } else {
    return ExpenseStore.regular_rules();
  }
  },

  highlight: function (ruleId) {
    return this.state.filterByRuleId === ruleId;
  },

  render: function () {
    return (
      <table className='table table-striped table-hover'>
        <thead>
          { this.renderHeaders() }
        </thead>
        <tbody>
          { this.invoices().map( function (invoice, i) {
              return <ProjectionItem invoice={invoice} key={i} index={i} type={this.props.type} highlight={this.highlight(invoice.parent_id || invoice.id)} />
            }, this)
          }
        </tbody>
      </table>
    )
  },

  _onChange: function () {
    // set a simple state to refresh the list
    this.setState({ lastUpdated: new Date() });
  },

  _onFilter: function (id) {
    this.setState({ filterByRuleId: id });
  },

  renderHeaders: function () {
    return (
      <tr>
        <th>Rule ID</th>
        <th>Vendor</th>
        <th>Face Value</th>
        <th>Interval</th>
        <th>Issue Date (initial)</th>
        <th>Due Date</th>
      </tr>
    );
  }

});
