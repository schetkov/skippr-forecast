var ScenariosIndex = React.createClass({

  getInitialState: function() {
    return {
      scenarios: ScenarioStore.scenarios,
      selected_scenario: ScenarioStore.selected_scenario,
      button_disabled: true,
      loaded: false
    }
  },

  componentWillMount: function () {
    ScenarioStore.on('change', this._onChange);
    ScenarioStore.on('fully_loaded', this._onFullyLoaded)
  },

  componentWillUnmount: function () {
    ScenarioStore.off('change', this._onChange);
    ScenarioStore.off('fully_loaded', this._onFullyLoaded)
  },

  _onChange: function () {
    is_default_scenario = ScenarioStore.get_scenario(ScenarioStore.selected_scenario).title == 'Default Scenario'
    this.setState({
      scenarios: ScenarioStore.scenarios,
      selected_scenario: ScenarioStore.selected_scenario,
      button_disabled: is_default_scenario,
      loaded: false
    });
  },
  
  _onFullyLoaded: function(){
    this.setState({loaded: true});
  },
  
  selectScenario: function (e) {
    ScenarioStore.selected_scenario = e.target.value;
    this.setState({
      selected_scenario: e.target.value,
      button_disabled: true,
      loaded: false
    }, ScenariosActions.refreshScenario(e.target.value));
  },

  showForm: function (e) {
    e.preventDefault();
    MainDispatcher.dispatch({
      actionType: 'SHOW_SCENARIO_FORM',
      scenario: {
        title: '',
        mode: 'create'
      }
    });
  },

  editScenario: function (e) {
    e.preventDefault();
    e.stopPropagation();
    MainDispatcher.dispatch({
      actionType: 'SHOW_SCENARIO_FORM',
      scenario: {
        title: ScenarioStore.get_scenario(ScenarioStore.selected_scenario).title,
        mode: 'update'
      }
    });
  },

  deleteScenario: function (e) {
    e.preventDefault();
    e.stopPropagation();
    return confirmDelete('Are you sure?', {
      description: 'Would you like to remove this scenario from the list?',
      confirmLabel: 'Yes',
      abortLabel: 'No',
      props: this.props,
      state: this.state,
      loaded: this.loaded,
      button_disabled: this.button_disabled
    }).then((function(_this) {
      return function() {
      _this.setState({
        loaded: false,
        button_disabled: true
      }, ScenariosActions.delete(ScenarioStore.selected_scenario, _this.state), 
      )
      };
    })(this));
  },

  isButtonDisabled: function() {
    if (this.state.button_disabled) {
      return 'btn btn-default dropdown-toggle disabled';
    } else {
      return 'btn btn-default dropdown-toggle';
    }
  },

  renderButton: function () {
    return(
      <div className='create-button'>
        <input type='button' name='createScenario' value='Create Scenario' onClick={this.showForm} className='btn btn-primary'/>
      </div>
    )
  },

  renderList: function () {
    return(
      <div className='list'>
        <select name='ScenariosList' value={String(this.state.selected_scenario)} onChange={this.selectScenario} className='form-control' >
          { this.state.scenarios.map(function (c) {
              return <ListItemWrapper key={c.id} id={String(c.id)} data={c.title}/>;
            })
          }
        </select>
      </div>
    )
  },

  renderLinks: function() {
    return(
      <div className="btn-group links" role="group">
        <button type="button" className={this.isButtonDisabled()} data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Action <span className="caret"></span>
        </button>
        <ul className="dropdown-menu">
          <li><a href='' onClick={this.editScenario}>Edit Scenario</a></li>
          <li><a href='' className="removable" onClick={this.deleteScenario}> Delete Scenario </a></li>
        </ul>
      </div>
    )
  },

  render: function () {
    return (
      <div>
        <Loader loaded={this.state.loaded}></Loader>
        { this.renderButton() }
        { this.renderList() }
        { this.renderLinks() }
      </div>
    )
  }


})