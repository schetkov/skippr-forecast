var CashForm = React.createClass({
  
  timeout: 0,
  
  getInitialState: function () {
    return({
      cash: 0
    });
  },

  updateGraph: function (e) {
    
    if(this.timeout) {
        clearTimeout(this.timeout);
        this.timeout = null;
    }
    var that = this;
    this.timeout = setTimeout(function() {that.setState({ cash: e.target.value }, function (){
      MainDispatcher.dispatch({
        actionType: 'UPDATE_CASH',
        cash: this.state.cash
      });
    });
  }, 1500)
  },

  render: function () {
    return (
      <div className='row'>
        <div className='col-md-6'>
          <div className='config-section'>
            <div className='row'>
              <div className='col-md-4'>
                <h4>Starting Bank Balance</h4>
              </div>
              <div className='col-md-8'>
                <div className='input-group'>
                  <span className='input-group-addon'>$</span>
                  <input type='number' className='form-control' name='cash' ref='cash' defaultValue={this.state.cash} onChange={this.updateGraph} />
                  <span className='input-group-addon'>.00</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className='col-md-3'>
          <div className='config-section reports'>
            <h4>Total accounts payable outstanding: {RadarUtils.formatCurrency(InvoiceStore.payables_outstanding)}</h4>
          </div>
        </div>
        <div className='col-md-3'>
          <div className='config-section reports'>
            <h4>Total accounts receivable outstanding: {RadarUtils.formatCurrency(InvoiceStore.invoices_outstanding)}</h4>
          </div>
        </div>

      </div>
    )
  }


});
