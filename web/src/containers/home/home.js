import React, { Component } from 'react';
import { connect } from 'react-redux';
import { NavigationBar } from '../navigationbar';
import { Modal, Button, Form } from 'react-bootstrap';
import { addMonitorVisibility, MonitorVisibility } from '../../actions/monitor';

class Home extends Component {
  render() {
    return (
      <div>
        <NavigationBar />

        <Modal size="lg" show={this.props.addMonitorVisibility} onHide={this.props.hideAddMonitor}>
          <Modal.Header closeButton>
            <Modal.Title>Add a new monitor</Modal.Title>
          </Modal.Header>

          <Modal.Body>
            <Form>
              <Form.Group>
                <Form.Label>eBay URL</Form.Label>
                <Form.Control type="text" />
              </Form.Group>
            </Form>
          </Modal.Body>

          <Modal.Footer>
            <Button variant="secondary" onClick={() => this.props.hideAddMonitor()}>Cancel</Button>
            <Button variant="primary">Add</Button>
          </Modal.Footer>
        </Modal>
      </div>
    );
  }
}

export default connect(
  (state) => ({
    addMonitorVisibility: state.monitor.addMonitorVisbility
  }),
  (dispatch) => ({
    hideAddMonitor: () => dispatch(addMonitorVisibility(MonitorVisibility.HIDE))
  })
)(Home);