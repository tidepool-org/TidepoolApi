# Time Change (`timeChange`)

### Table of Contents

1. [Quick summary](#quick-summary)
2. [Sub-type](#subtype-subtype)
3. [Change](#change-change)
4. [Example (client)](#example-client)
5. [Example (ingestion)](#example-ingestion)
6. [Example (storage)](#example-storage)
7. [Keep reading](#keep-reading)

---

## Quick summary

```json json_schema
{
  "title": "Time change",
  "type": "object",
  "properties": {
    "$ref": "../../../../reference/data/models/devicetimechange.v1.yaml"
  }
}
```

---

## Sub-type (`subType`)

A time change event represents an instance when a diabetes device user changed the display date & time settings on the device. An accurate history of time change events is crucial as Platform uses the most recent set of time change events, raw log from a device's records and user's selection of timezone to translate relative (local time) timestamps of device records into UTC timestamps. This is to align all diabetes device timelines. For further information, please see ["Bootstrapping" to UTC](./datetime/btutc.md).

All the relevant data from the time change event is stored in various fields on an embedded change object.

---

## Change (`change`)

Contains the following properties:

* From
* To
* Method

When a device's date & time is updated, the **to**, **from** and **method** fields should be included within the change embedded object on a time change event. The from field details the date & time the device *is being changed from* (the old date & time). The to field details the date & time the device *is being changed to* (the new date & time). Both the from and to properties are formatted as ISO 8601 timestamps without any offset from UTC specified; this is the exact same "relative" timestamp format used for [device time](./device-data/common-fields.md#device-time-devicetime).

The method field on the change object details whether the time change was manual (user-initiated) or automatic (initiated by the device).

---

## Example (client)

```json
{
    "type": "deviceEvent",
    "subType": "timeChange",
    "change": {
        "from": "2018-05-14T08:17:08",
        "to": "2018-05-14T07:20:33",
        "agent": "manual"
    },
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "7a91b3bc-2808-4c92-8769-3526db11ce41",
    "id": "0ccaad06f9104c098595cf6e871edc09",
    "time": "2018-05-14T08:17:08.814Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (ingestion)

```json
{
    "type": "deviceEvent",
    "subType": "timeChange",
    "change": {
        "from": "2018-05-14T08:17:08",
        "to": "2018-05-14T07:20:33",
        "agent": "manual"
    },
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "time": "2018-05-14T08:17:08.815Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (storage)

```json
{
    "type": "deviceEvent",
    "subType": "timeChange",
    "change": {
        "from": "2018-05-14T08:17:08",
        "to": "2018-05-14T07:20:33",
        "agent": "manual"
    },
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:13.815Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "2f17e38d-a39a-4116-a11c-5f014ea9ddd4",
    "id": "8f3abbd0fe4f49879f1bd8b2356c1942",
    "time": "2018-05-14T08:17:08.815Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

### Keep reading

* [Alarm](./device-data/data-types/device-event/alarm.md)
* [Bootstrapping to UTC](./datetime/btutc.md)
* [Calibration](./device-data/data-types/device-event/calibration.md)
* [Common fields](./device-data/common-fields.md)
* [Device event](./device-data/data-types/device-event.md)
* [Prime](./device-data/data-types/device-event/prime.md)
* [Pump settings](device-data/data-types/pump-settings)
* [Reservoir change](./device-data/data-types/device-event/reservoir-change.md)
* [Status](./device-data/data-types/device-event/status.md)
