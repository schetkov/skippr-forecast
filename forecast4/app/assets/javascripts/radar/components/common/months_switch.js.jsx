var MonthsSwitch = React.createClass({

  getInitialState: function() {
    return {
      half_year: true
    }
  },
  
  componentDidMount: function() {
    GraphStore.on('change_with_months', this._onGetMonths);
  },
  
  componentWillUnmount: function() {
    GraphStore.off('change_with_months', this._onGetMonths);
  },
  
  _onGetMonths: function() {
    if (this.state.half_year == true) {
      GraphStore.emit('half_year');
    } else {
      GraphStore.emit('quart_year');
    }
  },
  
  smallGraph: function(e) {
    this.setState({half_year: false});
    GraphStore.emit('quart_year');
  },
  wideGraph: function(e) {
    this.setState({half_year: true});
    GraphStore.emit('half_year')
  },

  render: function () {
    return(
      <div className='check_months list'>
        <a href="#" name='MonthSwitch' onClick={this.smallGraph}  className={this.state.half_year ? 'btn btn-default btn-sm' : 'btn btn-primary btn-sm'}  value = '3 months'> 3 months </a>
        <a href="#" name='MonthSwitch' onClick={this.wideGraph} className={this.state.half_year ? 'btn btn-primary btn-sm' : 'btn btn-default btn-sm'} value = '6 months'> 6 months </a>
      </div>
    )
  }

})