# Scheduled Basals (`scheduled`)

### Table of Contents

1. [Quick summary](#quick-summary)
2. [Delivery type](#delivery-type-deliverytype)
3. [Example (client)](#example-client)
4. [Example (ingestion)](#example-ingestion)
5. [Example (storage)](#example-storage)
6. [Keep reading](#keep-reading)

---

## Quick summary

```json json_schema
{
  "title": "Scheduled basals",
  "type": "object",
  "properties": {
    "$ref": "../../../../reference/data/models/basalscheduled.v1.yaml"
  }
}
```

---

## Delivery type (`deliveryType`)
This is the sub-type of basal event that represents intervals of basal insulin delivery triggered by the pump itself according to the active basal schedule programmed by the user (or clinician).

---

## Example (client)

```json
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

---

## Example (ingestion)

```json
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

---

## Example (storage)

```json
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

### Keep reading

* [Automated basals](./device-data/data-types/basal/automated.md)
* [Basal](./device-data/data-types/automated.md)
* [Common fields](./device-data/common-fields.md)
* [Pump settings](./device-data/pump-settings.md)
* [Suppressed basals](./device-data/data-types/basal/suppressed.md)
* [Suspend basals](./device-data/data-types/basal/suspend.md)
* [Temporary basals](./device-data/data-types/basal/temp.md)
* [Units](./device-data/units.md)
