var RuleItem = React.createClass({

  getInitialState: function () {
    var rule = this.props.rule;
    return {
      id: rule.id,
      rule_type: rule.rule_type,
      debtor_id: rule.debtor_id,
      vendor_id: rule.vendor_id,
      initial_date: rule.initial_date,
      due_date: rule.due_date,
      currency_code: rule.currency_code,
      terms: rule.terms,
      amount: rule.amount,
      interval: rule.interval,
      reccuring: rule.reccuring
    }
  },

  componentWillMount: function () {
    if(this.props.type === 'sales_forecast') {
      this.store = SalesStore;
    } else {
      this.store = ExpenseStore;
    }
    this.dispatcher = MainDispatcher;
  },

  editSalesRule: function (e) {
    e.preventDefault();
    e.stopPropagation();
    this.dispatcher.dispatch({
      actionType: 'SHOW_SALES_RULE_FORM',
      rule: {
        id: this.props.rule.id,
        index: this.props.index,
        rule_type: this.props.rule.rule_type,
        debtor_id: this.props.rule.debtor_id,
        vendor_id: this.props.rule.vendor_id,
        initial_date: this.props.rule.initial_date,
        due_date: this.props.rule.due_date,
        terms: this.props.rule.terms,
        amount: this.props.rule.amount,
        interval: this.props.rule.interval,
        due_date: this.props.rule.due_date,
        other_expenses_name: this.props.rule.other_expenses_name,
        reccuring: this.props.rule.reccuring
      }
    });
  },

  deleteSalesRule: function (e) {
    e.stopPropagation();
    return confirmDelete('Are you sure?', {
      description: 'Would you like to remove this rule from the list?',
      confirmLabel: 'Yes',
      abortLabel: 'No',
      props: this.props,
      state: this.state
    }).then((function(_this) {
      return function() {
        RulesActions.delete(ScenarioStore.selected_scenario, _this.props, _this.state);
      };
    })(this));
  },
  
  filterProjectedRules: function (e) {
    this.dispatcher.dispatch({ actionType: 'FILTER_RULES', ruleId: this.state.id });
  },

  clearFilteredProjectedRules: function (e) {
    this.dispatcher.dispatch({ actionType: 'FILTER_RULES', ruleId: null });
  },

  renderCustomer: function (){
    return (
      <div>
        {CustomerStore.customerNameById(this.props.rule.debtor_id)}
      </div>
    )
  },

  renderVendor: function (){
    if (this.props.rule.rule_type == 'other_expenses') {
      return (
      <div>
        {this.props.rule.other_expenses_name}
      </div>
      )
    } else {
    return (
      <div>
        {VendorStore.vendorNameById(this.props.rule.vendor_id)}
      </div>
      )
    }
  },

  renderContact: function () {
    if(this.props.type === 'sales_forecast') {
      return this.renderCustomer();
    } else {
      return this.renderVendor();
    }
  },

  render: function () {
    return (
      <div href="#" className='list-group-item -rule' onClick={this.editSalesRule} onMouseEnter={this.filterProjectedRules} onMouseLeave={this.clearFilteredProjectedRules}>
        <h4 className='list-group-item-heading'>
          {this.renderContact()}
        </h4>
        <div className='list-group-item-text'>
          <div className='amount-text'>${this.props.rule.amount}</div>
          Id: {this.props.rule.id} /
          Terms: {this.props.rule.terms} /
          Interval: {this.props.rule.interval} /
          Start Date: {moment(this.props.rule.initial_date).format('YYYY-MM-DD')} /
          &nbsp;<a href="#" onClick={this.deleteSalesRule} > Delete this rule </a>
        </div>
        <div className='edit-hint'>Click to edit</div>
      </div>
    )
  }

});
