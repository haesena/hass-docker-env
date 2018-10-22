thermostat_id = data.get('thermostat')
sensor_id  = data.get('sensor')

thermostat = hass.states.get(thermostat_id)
attributes = thermostat.attributes.copy()

if sensor_id is not None and sensor_id != "":
  sensor = hass.states.get(sensor_id)
  temp = sensor.state
  if temp is not None and temp is not "Unknown":
    attributes = thermostat.attributes.copy()
    attributes['current_temperature'] = temp  

if float(attributes['temperature']) > 15:
  state = 'On'
else:
  state = 'Off'

hass.states.set(thermostat_id, state, attributes)
