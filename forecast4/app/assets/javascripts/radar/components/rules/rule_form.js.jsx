var SalesRuleForm = React.createClass({

  getInitialState: function (){
    return({
      customer: 'Yay',
      amount: 0,
      initial_date: '',
      interval: 30,
      terms: 30,
      rule_type: 'sales',
      due_date: '',
      reccuring: null,
      debtor_id: null,
      vendor_id: null,
      other_expenses_name: null
    });
  },

  componentDidMount: function () {
    SalesStore.on('show_form', this._onChange);
    SalesStore.on('close_form', this.closeForm);

    ExpenseStore.on('show_form', this._onChange);
    ExpenseStore.on('close_form', this.closeForm);
  },

  componentWillUnmount: function () {
    SalesStore.off('show_form', this._onChange);
    SalesStore.off('close_form', this.closeForm);

    ExpenseStore.off('show_form', this._onChange);
    ExpenseStore.off('close_form', this.closeForm);
  },

  update: function (e) {
    var new_state = {}
    new_state[e.target.name] = e.target.value;
    this.setState(new_state);
  },

  modalInstance: function() {
    var modal = ReactDOM.findDOMNode(this);
    return $(modal);
  },

  submitForm: function () {
    if (this.state.initial_date > this.state.due_date) {
      alert("Due date can't be less than Initial date. Please change either \"Date expense incurred\" or \"Due date\" field.")
    } else {
    RulesActions.submit(ScenarioStore.selected_scenario, this.state);
    }
  },

  showForm: function () {
    this.modalInstance().modal('show');
  },

  closeForm: function () {
    this.modalInstance().modal('hide');
  },

  setInitialDate: function (date) {
      this.setState({initial_date: date});
  },

  setDueDate: function (date) {
      this.setState({due_date: date});
  },

  _onChange: function(rule) {

    if(rule.rule_type === 'sales') {
      this.store = SalesStore;
    } else {
      this.store = ExpenseStore;
    }

    this.dispatcher = MainDispatcher;

    this.setState({
      id: rule.id,
      amount: rule.amount,
      debtor_id: rule.debtor_id,
      vendor_id: rule.vendor_id,
      other_expenses_name: rule.other_expenses_name,
      initial_date: rule.initial_date,
      interval: rule.interval || 30,
      terms: rule.terms || 30,
      id: rule.id,
      index: rule.index,
      rule_type: rule.rule_type,
      due_date: rule.due_date,
      reccuring: rule.reccuring
    }, this.showForm)
  },

  modalTitle: function () {
    if(this.state.rule_type === 'sales') {
      return 'Sales Rule';
    } else if (this.state.rule_type == "expenses") {
      return 'Expense Rule';
    } else {
      return 'Other expense rule';
    }
  },

  setReccuring: function() {
    this.setState({reccuring: !this.state.reccuring});
    $(ReactDOM.findDOMNode(this)).find('input[type="checkbox"]').attr('checked', this.state.reccuring);
  },

  renderCustomers: function () {
    return (
      <div>
        <label htmlFor='debtor_id'>Customer</label>
        <br/>
        <select name='debtor_id' value={this.state.debtor_id} defaultValue={String(this.state.debtor_id)} onChange={this.update} className='form-control'>
          { CustomerStore.customers.map(function (c) {
              return <ListItemWrapper key={c.id} id={String(c.id)} data={c.legal_business_name}/>;
            })
          }
        </select>
      </div>
    )
  },

  renderVendors: function () {
    return (
      <div>
        <label htmlFor='vendor_id'>Vendor</label>
        <br/>
        <select name='vendor_id' value={this.state.vendor_id} defaultValue={String(this.state.vendor_id)} onChange={this.update} className='form-control'>
          { VendorStore.vendors.map(function (c) {
              return <ListItemWrapper key={c.id} id={String(c.id)} data={c.legal_business_name}/>;
            })
          }
        </select>
      </div>
    )
  },

  renderOtherExpenseNames: function () {
    return (
      <div>
        <label htmlFor='other_expenses_name'>Other Expense Name</label>
        <br/>
        <select name='other_expenses_name' value={this.state.other_expenses_name} defaultValue={String(this.state.other_expenses_name)} onChange={this.update} className='form-control'>
          <option value="GST"> GST </option>
          <option value="PAYG"> PAYG </option>
          <option value="Supperannuation"> Supperannuation </option>
          <option value="General"> General </option>
          <option value="Other"> Other </option>
        </select>
      </div>
    )
  },

  renderContacts: function () {
    if(this.state.rule_type === 'sales') {
      return this.renderCustomers();
    } else if (this.state.rule_type == 'expenses') {
      return this.renderVendors();
    } else {
      return this.renderOtherExpenseNames();
    }
  },

  render: function () {
    if (this.state.rule_type != 'other_expenses') {
      return (
        <div className='modal fade' role='dialog'>
          <div className='modal-dialog'>
            <div className='modal-content'>
              <form className='form'>
                <div className='modal-header'>
                  <h4 className='modal-title'>{this.modalTitle()}</h4>
                </div>
                <div className='modal-body'>
                  <div className='form-group'>
                    {this.renderContacts()}
                  </div>
                  <div className='form-group'>
                    <label htmlFor='amount'>Amount</label>
                    <input type='text' name='amount'  value={this.state.amount} onChange={this.update} className='form-control' />
                  </div>
                  <div className='form-group'>
                    <label htmlFor='initial_date'>{this.state.rule_type == 'sales' ? "Sales Date" : "Date expense incurred" }</label>
                    <div className='input-group'>
                      <DatePicker defaultValue={this.state.initial_date} changeHandle={this.setInitialDate} />
                    </div>
                  </div>
                  <div className='form-group'>
                    <label htmlFor='terms'>{this.state.rule_type == 'sales' ? "Sales Payment Terms" : "Payment Terms (days)" } </label>
                    <input type='text' name='terms' value={this.state.terms} onChange={this.update} className='form-control' />
                  </div>
                  <div className='form-group'>
                    <label htmlFor='interval'>{this.state.rule_type == 'sales' ? "Purchase Order Cycle (days)" : "Expense Cycle (days)" } </label>
                    <input type='text' name='interval' value={this.state.interval} onChange={this.update} className='form-control' />
                  </div>
                </div>
                <div className='modal-footer'>
                  <button type='button' className='btn btn-default' onClick={this.closeForm}>Cancel</button>
                  <button type='button' className='btn btn-primary' onClick={this.submitForm}>Save</button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )
    } else {
      return (
        <div className='modal fade' role='dialog'>
          <div className='modal-dialog'>
            <div className='modal-content'>
              <form className='form'>
                <div className='modal-header'>
                  <h4 className='modal-title'>{this.modalTitle()}</h4>
                </div>
                <div className='modal-body'>
                  <div className='form-group'>
                    {this.renderContacts()}
                  </div>
                  <div className='form-group'>
                    <label htmlFor='amount'>Amount</label>
                    <input type='text' name='amount'  value={this.state.amount} onChange={this.update} className='form-control' />
                  </div>
                  <div className='form-group'>
                    <label htmlFor='initial_date'> Date expense incurred </label>
                    <div className='input-group'>
                      <DatePicker defaultValue={this.state.initial_date} changeHandle={this.setInitialDate} />
                    </div>
                  </div>
                  <div className='form-group'>
                    <label htmlFor='due_date'> Due date </label>
                    <div className='input-group'>
                      <DatePicker defaultValue={this.state.due_date} changeHandle={this.setDueDate} />
                    </div>
                  </div>
                  <div>
                  <label htmlFor='reccuring'> Reccuring transaction </label>
                  &nbsp; &nbsp;
                  <input type="checkbox" checked={this.state.reccuring} onChange={this.setReccuring}></input>
                  </div>
                  <div className='form-group' style={(this.state.reccuring)? {display: 'block'} : {display: 'none'}}>
                    <label htmlFor='interval'> Expense Cycle (days) </label>
                    <input type='text' name='interval' value={this.state.interval} onChange={this.update} className='form-control' />
                  </div>
                </div>
                <div className='modal-footer'>
                  <button type='button' className='btn btn-default' onClick={this.closeForm}>Cancel</button>
                  <button type='button' className='btn btn-primary' onClick={this.submitForm}>Save</button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )
    }
  }
});
