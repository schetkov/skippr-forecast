var ScenarioStore = new EventEmitter();

ScenarioStore.dispatchToken = MainDispatcher.register(function (payload) {
  var action = payload.actionType;
  switch(action) {
    case 'SHOW_SCENARIO_FORM':
      ScenarioStore.emit('show_form', payload.scenario);
      break;
    case 'CREATE_SCENARIO':
      ScenarioStore.createScenario(payload.scenario);
      break;
    case 'UPDATE_SCENARIO':
      ScenarioStore.updateScenario(payload.scenario);
      break;
    case 'DELETE_SCENARIO':
      ScenarioStore.deleteScenario();
      break;
    default:
  }
});

ScenarioStore.scenarios = [];
ScenarioStore.selected_scenario = 0;

ScenarioStore.default_scenario = function () {
  return _.first(ScenarioStore.scenarios);
};

ScenarioStore.get_scenario = function (id) {
  return _.findWhere(ScenarioStore.scenarios, { id : parseInt(id)});
};

ScenarioStore.delete_selected_scenario = function () {
  ScenarioStore.scenarios.splice(_.indexOf(ScenarioStore.scenarios,
    _.findWhere(ScenarioStore.scenarios, { id : parseInt(ScenarioStore.selected_scenario)})), 1);
  ScenarioStore.selected_scenario = ScenarioStore.default_scenario().id;
};

ScenarioStore.update_selected_scenario = function (scenario) {
  ScenarioStore.scenarios.splice(_.indexOf(ScenarioStore.scenarios,
    _.findWhere(ScenarioStore.scenarios, { id : parseInt(scenario.id)})), 1, scenario);
};

ScenarioStore.createScenario = function (scenario) {
  ScenarioStore.scenarios.push(scenario);
  ScenarioStore.selected_scenario = scenario.id;
  ScenariosActions.refreshScenario(scenario.id);
  ScenarioStore.emit('change');
  ScenarioStore.emit('close_form');
};

ScenarioStore.updateScenario = function (scenario) {
  ScenarioStore.update_selected_scenario(scenario);
  ScenarioStore.emit('change');
  ScenarioStore.emit('close_form');
  ScenariosActions.refreshScenario(scenario.id);
};


ScenarioStore.deleteScenario = function () {
  ScenarioStore.delete_selected_scenario();
  ScenariosActions.refreshScenario(ScenarioStore.selected_scenario);
  ScenarioStore.emit('change');
};