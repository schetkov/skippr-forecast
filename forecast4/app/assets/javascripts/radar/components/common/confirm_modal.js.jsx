var Modal = React.createClass({
  displayName: 'Modal',
  backdrop: function() {
    return <div className='modal-backdrop in' />;
  },
  modal: function() {
    var style = {display: 'block'};
    return (
      <div
        className='modal in'
        tabIndex='-1'
        role='dialog'
        aria-hidden='false'
        ref='modal'
        style={style}
      >
        <div className='modal-dialog'>
          <div className='modal-content'>
            {this.props.children}
          </div>
        </div>
      </div>
    );
  },
  render: function() {
    return (
      <div>
        {this.backdrop()}
        {this.modal()}
      </div>
    );
  }
});
var Confirm = React.createClass({
  displayName: 'Confirm',
  getDefaultProps: function() {
    return {
      confirmLabel: 'OK',
      abortLabel: 'Cancel'
    };
  },
  abort: function() {
    return this.promise.reject();
  },
  confirm: function() {
    return this.promise.resolve();
  },
  componentDidMount: function() {
    this.promise = new $.Deferred();
    return ReactDOM.findDOMNode(this.refs.confirm).focus();
  },
  render: function() {
    var modalBody;
    if (this.props.description) {
      modalBody = (
        <div className='modal-body'>
          {this.props.description}
        </div>
      );
    }
    return (
      <Modal>
        <div className='modal-header'>
          <h4 className='modal-title'>
            {this.props.message}
          </h4>
        </div>
        {modalBody}
        <div className='modal-footer'>
          <div className='text-right'>
            <button
              role='abort'
              type='button'
              className='btn btn-default'
              onClick={this.abort}
            >
              {this.props.abortLabel}
            </button>
            {' '}
            <button
              role='confirm'
              type='button'
              className='btn btn-primary'
              ref='confirm'
              onClick={this.confirm}
            >
              {this.props.confirmLabel}
            </button>
          </div>
        </div>
      </Modal>
    );
  }
});