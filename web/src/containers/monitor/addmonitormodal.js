import React from 'react';
import { Modal, Button, Form } from 'react-bootstrap';

function AddMonitorModal(props) {
  return (
    <Modal size="lg" show={props.show} onHide={props.cancelAction}>
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
        <Button variant="secondary" onClick={props.cancelAction}>Cancel</Button>
        <Button variant="primary">Add</Button>
      </Modal.Footer>
    </Modal>
  );
}

export default AddMonitorModal;