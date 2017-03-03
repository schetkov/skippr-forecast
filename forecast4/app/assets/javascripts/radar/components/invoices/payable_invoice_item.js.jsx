var PayableInvoiceItem = React.createClass({
  getInitialState: function() {
    return {
      id: this.props.invoice.id,
      face_value: this.props.invoice.face_value,
      initial_date: this.props.invoice.date,
      vendor_id: this.props.invoice.vendor_id,
      date: this.props.invoice.date,
      due_date: this.props.invoice.due_date,
      due_date_copy: this.props.invoice.due_date,
      anticipated_pay_date: moment(this.props.invoice.anticipated_pay_date).format('YYYY-MM-DD'),
      amount_due: this.props.invoice.amount_due,
      is_hidden: this.props.invoice.is_hidden,
      terms: this.props.invoice.terms,
      rule_type: this.props.invoice.rule_type,
      other_expenses_name: this.props.invoice.other_expenses_name
    }
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState({
      is_hidden: nextProps.invoice.is_hidden,
      due_date: nextProps.invoice.due_date,
      due_date_copy: nextProps.invoice.due_date,
      anticipated_pay_date: nextProps.invoice.anticipated_pay_date,
      terms: nextProps.invoice.terms,
      vendor_id: nextProps.invoice.vendor_id,
      date: nextProps.invoice.date,
      initial_date: nextProps.invoice.date,
      debtor_id: nextProps.invoice.debtor_id,
      rule_type: this.props.invoice.rule_type,
      other_expenses_name: nextProps.invoice.other_expenses_name
    });
  },
  
  updateAnticipatedDate: function(date) {
    this.setState({anticipated_pay_date: date}, this.notifyServer);
  },

  hideInvoice: function(e) {
    e.stopPropagation();
    this.setState({ is_hidden: !this.state.is_hidden }, this.notifyServer);
  },

  hideRule: function(e) {
    e.stopPropagination;
    this.setState({ is_hidden: !this.state.is_hidden }, this.notifyServerRule);
  },

  deletePayable: function(e) {
    return confirmDelete('Are you sure?', {
      description: 'Would you like to remove this invoice from the list?',
      confirmLabel: 'Yes',
      abortLabel: 'No',
      props: this.props,
      state: this.state
    }).then((function(_this) {
      return function() {
         InvoicesActions.deletePayable(ScenarioStore.selected_scenario, _this.props, _this.state);
      };
    })(this));
  },

  notifyServer: function(e) {
    InvoicesActions.updatePayables(ScenarioStore.selected_scenario, this.state);

    MainDispatcher.dispatch({
      actionType: 'PAYABLE_ITEM_UPDATE',
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

  renderPayable: function() {
    if(this.props.invoice.projected) {
      return (
        <tr className={this.getaClassName()}>
          <td>{ this.props.invoice.rule_type == 'other_expenses' ? this.state.other_expenses_name : VendorStore.vendorNameById(this.props.invoice.vendor_id)}</td>
          <td>{RadarUtils.formatCurrency(this.props.invoice.face_value)}</td>
          <td>{moment(this.props.invoice.initial_date).format('YYYY-MM-DD')}</td>
          <td>{moment(this.state.due_date).format('YYYY-MM-DD')}</td>
          <td></td>
          <td><input type='submit' name='hideButton' value={this.state.is_hidden ? 'Show' : 'Hide'} onClick={this.hideRule}
              className={this.state.is_hidden ? 'btn btn-warning' : 'btn btn-default'} /></td>
          <td></td>
        </tr>
      );
    } else {
      return (
        <tr className={this.getaClassName()}>
          <td>{ this.props.invoice.rule_type == 'other_expenses' ? this.state.other_expenses_name : VendorStore.vendorNameById(this.props.invoice.vendor_id)}</td>
          <td>{RadarUtils.formatCurrency(this.props.invoice.face_value)}</td>
          <td>{this.props.invoice.date}</td>
          <td>{moment(this.state.due_date).format('YYYY-MM-DD')}</td>
          <td><DatePicker defaultValue={this.state.anticipated_pay_date} changeHandle={this.updateAnticipatedDate} /></td>
          <td>
            <input type='submit' name='hideButton' value={this.state.is_hidden ? 'Show' : 'Hide'} onClick={this.hideInvoice}
              className={this.state.is_hidden   
  
  ? 'btn btn-warning' : 'btn btn-default'} />
          </td>
          <td> <a className="removable btn btn-danger" onClick = {this.deletePayable}> DELETE </a> </td>
        </tr>
      );
    }
  },

  render: function() {
    return this.renderPayable()
  }

})

