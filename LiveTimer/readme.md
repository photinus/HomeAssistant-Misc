# Components
 - HACS - https://hacs.xyz/
 - Alexa Media Custom Component - https://github.com/custom-components/alexa_media_player
 - Config Template Card - https://github.com/iantrich/config-template-card
 - JQuery Countdown - https://github.com/photinus/jquery-countdown (forked from Github User reflejo, fixed a bug, their repo is stale)

# Config Snippits

## Time Remaining Sensor
sensor.kitchen_next_timer_2 is the sensor associated with my Kitchen Amazon Echo
```
  - platform: template
    sensors:
      template_kitchen_timer:
        friendly_name: 'Kitchen Timer End Time'
        value_template: '{{ (as_timestamp(states("sensor.kitchen_next_timer_2"))  | timestamp_custom("%H:%M:%S")) }}'
```

## HA Timer Entity
```
timer:
  kitchen_echo:
```

## Automations
```
- id: '1588025947405'
  alias: SetupTimer
  description: ''
  trigger:
  - entity_id: sensor.kitchen_next_timer_2
    from: unavailable
    platform: state
  condition: []
  action:
  - data_template:
      duration: >
        {{(as_timestamp(states('sensor.kitchen_next_timer_2')) - as_timestamp(now())) | timestamp_custom("%H:%M:%S", false)}}
    entity_id: timer.kitchen_echo
    service: timer.start
- id: '1588100241295'
  alias: TeardownTimer
  description: ''
  trigger:
  - entity_id: sensor.kitchen_next_timer_2
    platform: state
    to: unavailable
  condition: []
  action:
  - data: {}
    entity_id: timer.kitchen_echo
    service: timer.cancel

```

## Lovelace
```
- card:
    card:
       title: Kitchen Timer
       type: iframe
       url: >-
          ${'/local/countdown/index.html?timer='+states['sensor.template_kitchen_timer'].state}
       entities:
          - sensor.template_kitchen_timer
       type: 'custom:config-template-card'
    conditions:
      - entity: timer.kitchen_echo
        state: active
        type: conditional
    
