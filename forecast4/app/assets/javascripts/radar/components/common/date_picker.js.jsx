var DatePicker = React.createClass({

  _destroyDatePicker: function() {
    this._datePicker().datepicker('destroy');
  },

  _datePicker: function() {
    return $(ReactDOM.findDOMNode(this.refs.date_picker));
  },

  _initDatePicker: function() {
    this._datePicker().datepicker();
  },

  componentDidMount: function() {
    this._initDatePicker();
    this._datePicker().on('changeDate', this.updateDate);
  },

  shouldComponentUpdate: function(nextProps, nextState) {
    return nextProps.defaultValue !== this.props.defaultValue;
  },

  componentDidUpdate: function() {
   this._datePicker().off('changeDate');
   this._datePicker().datepicker('setDate', moment(this.props.defaultValue).toDate());
   this._datePicker().on('changeDate', this.updateDate);
 },

  componentWillUnmount: function() {
    this._destroyDatePicker();
  },

  updateDate: function(e) {
    this.props.changeHandle(moment(e.date).format('YYYY-MM-DD'));
  },

  render: function() {
    return (
      <div className="input-group date" >
        <input type="text" ref='date_picker' name='date_picker' data-date-format="yyyy-mm-dd"
          defaultValue={this.props.defaultValue} className="form-control" />
        <div className="input-group-addon">
          <span className="glyphicon glyphicon-th"></span>
        </div>
      </div>
    )
  }
});