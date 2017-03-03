var FilterInvoices = React.createClass({

  getInitialState: function() {
    return {
      sort: "all_invoices"
    }
  },

  update: function (e) {
    this.setState({ sort: e.target.value });
    InvoiceStore.selected_filter = e.target.value
    ScenariosActions.refreshScenario(ScenarioStore.selected_scenario)
  },

  render: function () {
    return(
      <div className='list'>
        <select name='SortingList' value={String(this.state.sort)} onChange={this.update} className='form-control' >
          <option value="all_invoices"> All invoices </option>
          <option value="overdue_invoices"> Overdue invoices </option>
          <option value="outstanding_invoices"> Outstanding invoices </option>
          <option value="rules_invoices"> Rules only </option>
        </select>
      </div>
    )
  }

})