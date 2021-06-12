# Automated Basals (`automated`)

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
  "title": "Automated basals",
  "type": "object",
  "properties": {
    "$ref": "../../../../reference/data/models/basalautomated.v1.yaml"
  }
}
```

---

## Delivery type (`deliveryType`)

This is the sub-type of basal event representing intervals of basal insulin delivery triggered by the pump itself (rather than manual user entry) according to a closed loop algorithm.

---

## Example (client)

```json
{
    "type": "basal",
    "deliveryType": "automated",
    "duration": 55800000,
    "rate": 1.825,
    "scheduleName": "Stress",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "guid": "de52b7f9-146f-48f1-a78b-069df20b700a",
    "id": "07d77d96e6854cb982027ed53db9594f",
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
    "deliveryType": "automated",
    "duration": 84600000,
    "rate": 0.525,
    "scheduleName": "Very Active",
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
    "deliveryType": "automated",
    "duration": 46800000,
    "rate": 1.175,
    "scheduleName": "Weekday",
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:00:05.000Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "guid": "b0b9c24b-00b1-4f0a-863a-5b4f09aa6720",
    "id": "6f513a7bb30445a69a8c30d134f2f0ce",
    "time": "2018-05-14T08:00:00.000Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

### Keep reading

* [Basal](./device-data/data-types/automated.md)
* [Common fields](./device-data/common-fields.md)
* [Pump settings](./device-data/pump-settings.md)
* [Scheduled basals](./device-data/data-types/basal/scheduled.md)
* [Suppressed basals](./device-data/data-types/basal/suppressed.md)
* [Suspend basals](./device-data/data-types/basal/suspend.md)
* [Temporary basals](./device-data/data-types/basal/temp.md)
* [Units](./device-data/units.md)
