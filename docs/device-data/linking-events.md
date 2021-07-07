# Linking Events

### Table of Contents

1. [Overview](#overview)
2. [Potentially linked events](#potentially-linked-events)
3. [How to link events](#how-to-link-events)
4. [Keep reading](#keep-reading)

---

## Overview

Not all events from diabetes management devices are independent. Some events are logically related — perhaps in a rough cause-and-effect relationship. In cases where there is a logical connection between events, Tidepool endeavors to preserve that connection in the standardized form of data stored in the Tidepool cloud.

---

## Potentially linked events

* Bolus calculator (`wizard`) -> Bolus (`bolus`)
* Alarm (`alarm`) -> Status (`status`)
* Reservoir Change (`resevoirChange`) -> Status (`status`)

---

## How to link events

Platform creates GUIDs for the ID of each event. This means that linked events such as pairs of wizard and bolus events *cannot* be uploaded separately. Instead, only the "outer" event is uploaded with the "inner" linked event embedded inside it. Upon ingestion of this compound event, Tidepool's Platform:

* Generates the GUID for the inner event and stores it on the inner event's ID field
* Extracts and stores the inner event as an independent event
* Updates the appropriate field on the outer event to contain just the GUID for the inner event instead of the entire object

The data for ingestion via Platform looks like:

```json
[
  {
    "type": "wizard",
    "bgInput": 32,
    "bgTarget": {
      "target": 85,
      "high": 145
    },
    "bolus": {
      "type": "bolus",
      "subType": "normal",
      "normal": 1,
      "clockDriftOffset": 0,
      "conversionOffset": 0,
      "deviceId": "DevId0987654321",
      "deviceTime": "2016-06-14T10:52:45",
      "time": "2016-06-14T17:52:45.845Z",
      "timezoneOffset": -420,
      "uploadId": "SampleUploadId"
  }
]
```

The resulting data looks like:

```json
[
  {
    "type": "bolus",
    "subType": "normal",
    "normal": 1,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2016-06-14T10:52:45",
    "time": "2016-06-14T17:52:45.845Z",
    "timezoneOffset": -420,
    "uploadId": "SampleUploadId",
    "_groupId": "f4c834c27a",
    "guid": "4c2f3acc-8d1d-4df0-bc88-2fad64df8151",
    "id": "9006526e4d8344a3987eea1a5f327426",
    "createdTime": "2016-06-14T18:03:50.662Z",
    "_version": 0,
    "_active": true,
    "_schemaVersion": 1
  }
]
```

---

### Keep reading

* [Alarm](./data-types/device-event/alarm.md)
* [Bolus](./data-types/bolus.md)
* [Bolus calculator](./data-types/pump-settings-calculator.md)
* [Common fields](./common-fields.md)
* [Reservoir change](./data-types/device-event/reservoir-change.md)
* [Status](./data-types/device-event/status.md)
