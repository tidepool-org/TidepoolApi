# Calibration (`calibration`)

## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Sub-Type](#subtype-subtype)
3. [Example (client)](#example-client)
4. [Example (ingestion)](#example-ingestion)
5. [Example (storage)](#example-storage)
6. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../../reference/data/models/devicecalibration.v1.yaml'
```

---

## Sub-Type (`subType`)

The calibration sub-type of device event represents a user's manual entry of a self-monitored glucose (SMBG) value to calibrate a continuous glucose monitoring (CGM) device.

---

## Example (ingestion)

```json
{
    "type": "deviceEvent",
    "subType": "calibration",
    "units": "mg/dL",
    "value": 129,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "time": "2018-05-14T08:17:08.097Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (storage)

```json
{
    "type": "deviceEvent",
    "subType": "calibration",
    "units": "mmol/L",
    "value": 17.873408531166618,
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:13.097Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "26c9190e-8bc5-4d39-82ff-5085275207fb",
    "id": "5637b3ce3ff24eaea5006d22d79b62ea",
    "time": "2018-05-14T08:17:08.097Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Alarm](./device-data/data-types/device-event/alarm.md)
* [Common Fields](./device-data/common-fields.md)
* [Continuous Blood Glucose (CBG)](./device-data/data-types/cbg.md)
* [Device Event](./device-data/data-types/device-event.md)
* [Prime](./device-data/data-types/device-event/prime.md)
* [Pump Settings](device-data/data-types/pump-settings)
* [Reservoir Change](./device-data/data-types/device-event/reservoir-change.md)
* [Status](./device-data/data-types/device-event/status.md)
* [Time Change](./device-data/data-types/device-event/time-change.md)
