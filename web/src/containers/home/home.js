import React, { Component } from 'react';
import { connect } from 'react-redux';
import { NavigationBar } from '../navigationbar';
import { Modal, Button } from 'react-bootstrap';
import { addMonitorVisibility, MonitorVisibility } from '../../actions/navigationbar';

class Home extends Component {
  render() {
    return (
      <div>
        <NavigationBar />

        <Modal show={this.props.addMonitorVisibility} onHide={this.props.hideAddMonitor}>
          <Modal.Header>
            <Modal.Title>Add a new monitor</Modal.Title>
          </Modal.Header>

          <Modal.Body>
            Blah
          </Modal.Body>

          <Modal.Footer>
            <Button variant="info">Add</Button>
            <Button variant="primary" onClick={() => this.props.hideAddMonitor()}>Cancel</Button>
          </Modal.Footer>
        </Modal>
      </div>
    );
  }
}

export default connect(
  (state) => ({
    addMonitorVisibility: state.navigationbar.addMonitorVisbility
  }),
  (dispatch) => ({
    hideAddMonitor: () => dispatch(addMonitorVisibility(MonitorVisibility.HIDE))
  })
)(Home);