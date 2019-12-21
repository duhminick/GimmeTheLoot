import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Navbar, Nav, Button } from 'react-bootstrap';
import { addMonitorVisibility, MonitorVisibility } from '../../actions/navigationbar';
import './navigationbar.css';

class NavigationBar extends Component {
  render() {
    return (
      <Navbar bg="dark" variant="dark" expand="lg">
        <Navbar.Brand>Gimme The Loot</Navbar.Brand>
        <Nav className="nav-links">
          <Button variant="primary" onClick={() => this.props.showAddMonitor()}>New Monitor</Button>
          <Button variant="info">Refresh</Button>
        </Nav>
      </Navbar>
    );
  }
}

export default connect(
  null,
  (dispatch) => ({
    showAddMonitor: () => dispatch(addMonitorVisibility(MonitorVisibility.SHOW))
  })
)(NavigationBar);