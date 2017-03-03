var RadarGraph = React.createClass({

  getInitialState: function () {
    return {
      graphType: 'area'
    }
  },

  componentDidMount: function() {
    var that = this;
    GraphStore.on('change', this._onChange);
    GraphStore.on('half_year', this._onWideGraph );
    GraphStore.on('quart_year', this._onThinGraph );
  },

  componentDidUpdate: function() {
    this.drawCharts();
  },

  componentWillUnmount: function() {
    GraphStore.off('change', this._onChange);
    GraphStore.off('half_year', this._onWideGraph );
    GraphStore.off('quart_year', this._onThinGraph );
  },

  setGraphTypeToLine: function (e) {
    e.preventDefault();
    e.stopPropagation();
    this.setState({ graphType: 'line' });
  },

  setGraphTypeToArea: function (e) {
    e.preventDefault();
    e.stopPropagation();
    this.setState({ graphType: 'area' });
  },

  render: function() {

    return(
      <div className='radar-graph'>
        <CashForm />
        <div className='row radar-graph-itself'>
          <div className='col-md-12'>
            {React.DOM.div({id: this.props.graphName})}
          </div>
        </div>
      </div>
    )
  },

  drawCharts: function(wideness) {
    var graphData = GraphStore.invoicesAsGraph(wideness);

    graphData.series[0].visible = GraphStore.visibility[0];
    graphData.series[1].visible = GraphStore.visibility[1];
    graphData.series[2].visible = GraphStore.visibility[2];
    graphData.series[3].visible = GraphStore.visibility[3];

    // Don't draw the chart at all if it's empty. Which will occur in a few cases: a) No invoices b) all invoices are ignored
    if(graphData.length === 1) {
      return;
    }
    var options = {
      chart: {
        renderTo: this.props.graphName,
        zoomType: 'x',
        type: this.state.graphType, // line, bar, area
      },
      title: {
        text: 'Cash Flow Forecast',
      },
      plotOptions: {
        series: {
          tooltip: {
            enabled: true,
            pointFormatter: function(args) {
            temp_str = ""
            temp_str += '<strong>' + this.series.name + ' ' + this.y
            for (var i = 0; i< 100; i++) {
              if (this["object"+i] != undefined) {temp_str += '<br><strong>' + this["object"+i].name + " : " + this["object"+i].amount }
            }
              return temp_str
            }
          },
          animation: {
            complete: function() {
              setTimeout(function() {
                ScenarioStore.emit('fully_loaded');
              }, 700)
            }
          },
          events: {
            hide: function() {
              shown_array = [];
              this.chart.series.forEach( function(series_item) {
                shown_array.push(series_item.visible);
              });
              MainDispatcher.dispatch({actionType: 'GET_SERIES_VISIBILITY', series: shown_array});
          },
            show: function() {
              shown_array = [];
              this.chart.series.forEach( function(series_item) {
                shown_array.push(series_item.visible);
              });
              MainDispatcher.dispatch({actionType: 'GET_SERIES_VISIBILITY', series: shown_array});
            }
          }
        }
      },
      xAxis: {
        type: 'datetime',
        categories: graphData.categories
      },
      yAxis: {
          plotLines: [{
              color: '#FF0000',
              width: 2,
              value: 0
          }]
      },
      series: graphData.series
  };

    // Purges the old chart to prevent memory leaks
    if(this.chart) {
      this.chart.destroy()
    }

    this.chart = new Highcharts.Chart(options);
    var that = this;
  },

  _onChange: function() {
    this.drawCharts();
  },

  _onWideGraph: function() {
    this.drawCharts(true);
  },

  _onThinGraph: function() {
    this.drawCharts(false)
  }
});
