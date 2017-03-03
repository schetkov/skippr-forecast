var ListItemWrapper = React.createClass({
  render: function() {
    return <option value={String(this.props.id)}>{this.props.data}</option>;
  }
});