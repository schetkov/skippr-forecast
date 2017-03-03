var ReceivableInvoiceItem = React.createClass({
  getInitialState: function() {
    return {
      id: this.props.invoice.id,
      face_value: this.props.invoice.face_value,
      terms: this.props.invoice.terms,
      date: this.props.invoice.date,
      debtor_id: this.props.invoice.debtor_id,
      due_date: this.props.invoice.due_date,
      due_date_copy: this.props.invoice.due_date,
      anticipated_pay_date: moment(this.props.invoice.anticipated_pay_date).format('YYYY-MM-DD'),
      is_sold: this.props.invoice.is_sold,
      is_hidden: this.props.invoice.is_hidden,
      is_sold: false,
      rule_type: 'sales'
    }
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState({
      is_sold: nextProps.invoice.is_sold,
      is_hidden: nextProps.invoice.is_hidden,
      due_date: nextProps.invoice.due_date,
      date: this.props.invoice.date,
      debtor_id: this.props.invoice.debtor_id,
      anticipated_pay_date: nextProps.invoice.anticipated_pay_date,
      terms: nextProps.invoice.terms,
      is_hidden: nextProps.invoice.is_hidden,
      rule_type: 'sales'
    });
  },

  updateAnticipatedDate: function(date) {
    this.setState({anticipated_pay_date: date}, this.notifyServer);
  },

  sellInvoice: function(e) {
    e.stopPropagation();
    if(this.state.is_sold){
      this.setState({ is_sold: false, due_date: this.state.due_date_copy }, this.notifyServer);
    } else{
      this.setState({ is_sold: true, due_date: moment(new Date()).format('YYYY-MM-DD') }, this.notifyServer);
    }
  },

  sellRuleNow: function(e) {
    e.stopPropagation();
    if(this.state.is_sold){
      this.setState({ is_sold: false, due_date: this.state.due_date_copy }, this.notifyServerRule);
    } else {
      this.setState({ is_sold: true, due_date: this.props.invoice.initial_date }, this.notifyServerRule);
    }
  },

  hideInvoice: function(e) {
    e.stopPropagation();
    this.setState({ is_hidden: !this.state.is_hidden }, this.notifyServer);
  },

  hideRule: function(e) {
    e.stopPropagation();
    this.setState({ is_hidden: !this.state.is_hidden }, this.notifyServerRule);
  },

  deleteInvoice: function(e) {
    return confirmDelete('Are you sure?', {
      description: 'Would you like to remove this invoice from the list?',
      confirmLabel: 'Yes',
      abortLabel: 'No',
      props: this.props,
      state: this.state
    }).then((function(_this) {
      return function() {
         InvoicesActions.deleteInvoice(ScenarioStore.selected_scenario, _this.props, _this.state);
      };
    })(this));
  },

  notifyServer: function(e) {
    InvoicesActions.updateInvoices(ScenarioStore.selected_scenario, this.state);

    MainDispatcher.dispatch({
      actionType: 'RECEIVABLE_ITEM_UPDATE',
      invoice: this.state,
      index: this.props.index,
      type: this.props.type
    })
  },

  notifyServerRule: function(e) {
    RulesActions.submit(ScenarioStore.selected_scenario, this.state);
  },

  isDateMissed: function () {
    var now = new Date();
    var nowDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    var due = new Date(this.state.due_date);
    var dueDate = new Date(due.getFullYear(), due.getMonth(), due.getDate());
    return dueDate < nowDate;
  },

  getaClassName: function () {
    if (this.isDateMissed()){
      return 'red'
    }
    else if (this.props.invoice.projected) {
      return 'projected blue'
    }
    else {
      return '';
    }
  },

  renderReceivable: function() {
    if(this.props.invoice.projected) {
      return (
        <tr className={this.getaClassName()}>
          <td>{CustomerStore.customerNameById(this.props.invoice.debtor_id)}</td>
          <td>{RadarUtils.formatCurrency(this.props.invoice.face_value)}</td>
          <td>{moment(this.props.invoice.initial_date).format('YYYY-MM-DD')}</td>
          <td>{moment(this.state.due_date).format('YYYY-MM-DD')}</td>
          <td></td>
          <td><input type='submit' name='sellRuleNow' value={this.state.is_sold ? 'Sold' : 'Sell'}
                onClick={this.sellRuleNow} className={this.state.is_sold ? 'btn btn-primary' : 'btn btn-info'} /></td>
          <td><input type='submit' name='hideButton' value={this.state.is_hidden ? 'Show' : 'Hide'} onClick={this.hideRule}
              className={this.state.is_hidden ? 'btn btn-warning' : 'btn btn-default'} /></td>
          <td></td>
        </tr>
      );
    } else {
      return (
        <tr className={this.getaClassName()}>
          <td>{CustomerStore.customerNameById(this.props.invoice.debtor_id)}</td>
          <td>{RadarUtils.formatCurrency(this.props.invoice.face_value)}</td>
          <td>{this.props.invoice.date}</td>
          <td>{this.state.due_date}</td>
          <td><DatePicker defaultValue={this.state.anticipated_pay_date} changeHandle={this.updateAnticipatedDate} /></td>
          <td>
            <input type='submit' name='sell_button' value={this.state.is_sold ? 'Sold' : 'Sell Now'} onClick={this.sellInvoice}
              className={this.state.is_sold ? 'btn btn-primary' : 'btn btn-success'} />
          </td>
          <td>
            <input type='submit' name='hideButton' value={this.state.is_hidden ? 'Show' : 'Hide'} onClick={this.hideInvoice}
              className={this.state.is_hidden ? 'btn btn-warning' : 'btn btn-default'} />
          </td>
          <td> <a className="removable btn btn-danger" onClick = {this.deleteInvoice}> DELETE </a> </td>
        </tr>
      );
    }
  },

  render: function() {
    return this.renderReceivable()
  }

})
