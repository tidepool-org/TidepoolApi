<!-- omit in toc -->
# Calibration (`calibration`)

<!-- omit in toc -->
## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Sub-Type (`subType`)](#sub-type-subtype)
3. [Examples](#examples)
4. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../../reference/data/models/devicecalibration.v1.yaml'
```

---

## Sub-Type (`subType`)

The calibration sub-type of device event represents a user's manual entry of a self-monitored glucose (SMBG) value to calibrate a continuous glucose monitoring (CGM) device.

---

## Examples

```json title="Example (ingestion)" lineNumbers=true
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

```json title="Example (storage)" lineNumbers=true
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

* [Alarm](./alarm.md)
* [Common Fields](../../common-fields.md)
* [Continuous Blood Glucose (CBG)](../cbg.md)
* [Device Event](../device-event.md)
* [Prime](./prime.md)
* [Pump Settings](../pump-settings.md)
* [Pump Settings Override](./pump-settings-override.md)
* [Reservoir Change](./reservoir-change.md)
* [Status](./status.md)
* [Time Change](./time-change.md)
