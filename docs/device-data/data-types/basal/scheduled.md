<!-- omit in toc -->
# Scheduled Basals (`scheduled`)

<!-- omit in toc -->
## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Delivery Type (`deliveryType`)](#delivery-type-deliverytype)
3. [Examples](#examples)
4. [Keep Reading](#keep-reading)

---

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../../reference/data/models/basal/scheduled.v1.yaml"
  }
/%}

---

## Delivery Type (`deliveryType`)

This is the sub-type of basal event that represents intervals of basal insulin delivery triggered by the pump itself according to the active basal schedule programmed by the user (or clinician).

---

## Examples

```json title="Example (client)" lineNumbers=true
{
    "type": "basal",
    "deliveryType": "scheduled",
    "duration": 84600000,
    "rate": 1.45,
    "scheduleName": "Very Active",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "guid": "9d161801-2607-4cb6-b4f8-457159c7786c",
    "id": "30f76219248d474fa7025b12f0e4b136",
    "time": "2018-05-14T08:00:00.000Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json title="Example (ingestion)" lineNumbers=true
{
    "type": "basal",
    "deliveryType": "scheduled",
    "duration": 82800000,
    "rate": 0.025,
    "scheduleName": "Weekend",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "time": "2018-05-14T08:00:00.000Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json title="Example (storage)" lineNumbers=true
{
    "type": "basal",
    "deliveryType": "scheduled",
    "duration": 79200000,
    "rate": 1.175,
    "scheduleName": "Vacation",
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:00:05.000Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "guid": "05d3bdbd-3ad3-4762-9a7b-2e8e27a601c3",
    "id": "33f00679ddf440ec95055114162d4821",
    "time": "2018-05-14T08:00:00.000Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Basal](../basal.md)
* [Common Fields](../../common-fields.md)
* [Pump Settings](../pump-settings.md)
* [Automated Basals](./automated.md)
* [Suppressed Basals](./suppressed.md)
* [Suspend Basals](./suspend.md)
* [Temporary Basals](./temp.md)
* [Units](../../units.md)
