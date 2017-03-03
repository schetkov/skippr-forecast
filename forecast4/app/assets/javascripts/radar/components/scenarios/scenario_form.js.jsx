var ScenarioForm = React.createClass({

  getInitialState: function() {
    return {title: ''};
  },

  componentDidMount: function () {
    ScenarioStore.on('show_form', this._showForm);
    ScenarioStore.on('close_form', this.closeForm);
  },
  
  componentWillUnmount: function () {
    ScenarioStore.off('show_form', this._showForm);
    ScenarioStore.off('close_form', this.closeForm);
  },

  _showForm: function (scenario) {
    this.setState({title: scenario.title, mode: scenario.mode}, this.showForm);
  },

  modalInstance: function() {
    var modal = ReactDOM.findDOMNode(this);
    return $(modal);
  },

  update: function (e) {
    this.setState({title: e.target.value});
  },

  submitForm: function () {
    if (this.state.mode == 'create'){
      ScenariosActions.create(this.state)
    } else {
      ScenariosActions.update(ScenarioStore.selected_scenario, this.state)
    }
  },

  showForm: function () {
    this.modalInstance().modal('show',);
  },

  closeForm: function () {
    this.modalInstance().modal('hide');
  },

  render: function () {
    return (
     <div className='modal fade' role='dialog'>
        <div className='modal-dialog'>
          <div className='modal-content'>
            <form className='form'>
              <div className='modal-header'>
                <h4 className='modal-title'>Create Scenario</h4>
              </div>
              <div className='modal-body'>
                <div className='form-group'>
                  <label htmlFor='title'>Name</label>
                  <input type='text' name='title'  value={this.state.title} onChange={this.update} className='form-control' />
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

})