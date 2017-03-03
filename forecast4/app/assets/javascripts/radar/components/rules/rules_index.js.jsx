var RulesIndex = React.createClass({

  getInitialState: function () {
    return ({
      lastUpdated: new Date()
    });
  },

  componentWillMount: function () {
    if(this.props.type === 'sales_forecast') {
      this.store = SalesStore;
      this.rule_type = 'sales';
      RulesActions.getRulesList(ScenarioStore.selected_scenario, 'receivables', InvoiceStore.selected_filter);
    } else  if (this.props.type == 'other_expenses_forecast'){
      this.store = ExpenseStore;
      this.rule_type = 'other_expenses';
      ExpenseStore.other_rules();
    } else {
      this.store = ExpenseStore;
      this.rule_type = 'expenses';
      RulesActions.getRulesList(ScenarioStore.selected_scenario, 'payables', InvoiceStore.selected_filter);
    }
    this.dispatcher = MainDispatcher;
    this.store.on('change', this._onChange);
  },

  componentWillUnmount: function () {
    this.store.off('change', this._onChange);
  },

  _onChange: function () {
    // set a simple state to refresh the list
    this.setState({lastUpdated: new Date()});
  },

  createSalesRule: function (e) {
    e.preventDefault();
    if (CustomerStore.default_customer() != undefined)
    {
      this.dispatcher.dispatch({
        actionType: 'SHOW_SALES_RULE_FORM',
        rule: {
          amount: 0,
          debtor_id: CustomerStore.default_customer().id,
          initial_date: moment().format('YYYY-MM-DD'),
          rule_type: this.rule_type
        }
      });
    } else {
      alert('Please create at least one customer');
    }
  },

  createExpenceRule: function (e) {
    e.preventDefault();
    if (VendorStore.default_customer() != undefined)
    {
      this.dispatcher.dispatch({
        actionType: 'SHOW_EXPENSE_RULE_FORM',
        rule: {
          amount: 0,
          vendor_id: VendorStore.default_customer().id,
          initial_date: moment().format('YYYY-MM-DD'),
          rule_type: this.rule_type
        }
      });
    } else {
      alert('Please create at least one vendor');
    }
  },

  createOtherExpenceRule: function (e) {
    e.preventDefault();
    this.dispatcher.dispatch({
      actionType: 'SHOW_EXPENSE_RULE_FORM',
      rule: {
        amount: 0,
        other_expenses_name: "GST",
        initial_date: moment().format('YYYY-MM-DD'),
        rule_type: this.rule_type,
        due_date: moment().format('YYYY-MM-DD')
      }
    });
  },

  createRule: function (e) {
    if(this.props.type === 'sales_forecast') {
      this.createSalesRule(e);
    } else if (this.props.type === 'other_expenses_forecast'){
      this.createOtherExpenceRule(e);
    } else {
      this.createExpenceRule(e);
    }
  },

  render: function () {
    if (this.props.type == 'expense_forecast') {
    return (
      <div className='rules-container'>
        <br/>

        <div className='list-group rules'>
          { ExpenseStore.regular_rules_without_clones().map(function (rule, i) {
            if (rule.is_clone != true ) {
              return <RuleItem rule={rule} key={rule.id} index={i} type={this.props.type} scenario={this.state.scenario} /> 
              }
            }, this)
          }
        </div>

        <a href='#' className='btn btn-primary btn-lg btn-block' onClick={this.createRule}>
          <i className='ion-plus' />&nbsp;Add Rule
        </a>

      </div>
    )
        } else if (this.props.type == 'other_expenses_forecast') {
          return (
      <div className='rules-container'>
        <br/>

        <div className='list-group rules'>
          { ExpenseStore.other_rules_without_clones().map(function (rule, i) {
            return <RuleItem rule={rule} key={rule.id} index={i} type={this.props.type} scenario={this.state.scenario} /> 
            }, this)
          }
        </div>

        <a href='#' className='btn btn-primary btn-lg btn-block' onClick={this.createRule}>
          <i className='ion-plus' />&nbsp;Add Rule
        </a>

      </div>
    )
        } else {
          return (
      <div className='rules-container'>
        <br/>

        <div className='list-group rules'>
          { SalesStore.rules_without_clones().map(function (rule, i) {
              return <RuleItem rule={rule} key={rule.id} index={i} type={this.props.type} scenario={this.state.scenario} /> 
            }, this)
          }
        </div>

        <a href='#' className='btn btn-primary btn-lg btn-block' onClick={this.createRule}>
          <i className='ion-plus' />&nbsp;Add Rule
        </a>

      </div>
    )
        }
  }

});
