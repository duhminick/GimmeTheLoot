import { ADD_MONITOR_VISIBILITY, MonitorVisibility } from '../actions/monitor';

const initialState = {
  addMonitorVisbility: MonitorVisibility.HIDE
};

export default (state = initialState, action) => {
  switch (action.type) {
    case ADD_MONITOR_VISIBILITY:
      return ({
        ...state,
        addMonitorVisbility: action.visible
      });
    default:
      return state;
  }
};