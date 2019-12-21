export const ADD_MONITOR_VISIBILITY = 'ADD_MONITOR_VISIBILITY';

export const MonitorVisibility = {
  SHOW: true,
  HIDE: false
}

export const addMonitorVisibility = (visible) => ({
  type: ADD_MONITOR_VISIBILITY,
  visible
});