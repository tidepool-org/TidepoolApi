# Suspend Basals (`suspend`)

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
  "title": "Suspend basals",
  "type": "object",
  "properties": {
    "$ref": "../../../../reference/data/models/basalsuspend.v1.yaml"
  }
}
```

---

## Delivery type (`deliveryType`)

This is the sub-type of basal event representing the total suspension of insulin delivery on a pump within the stream of basal events — which should be without gaps or overlaps. The user's inputs to suspend (and later resume) insulin delivery are part of Tidepool's [device event](./device-data/data-types/device-event.md) data type. We represent suspend intervals as a suspend basal to maintain a continuous stream of basal data, making the calculation of statistics (e.g. total basal dose per day) easier.

No rate field appears on suspend basal events. The rate is always zero, so this is redundant information.

---

## Example (client)

```json
{
    "type": "basal",
    "deliveryType": "suspend",
    "duration": 10800000,
    "expectedDuration": 12960000,
    "suppressed": {
        "type": "basal",
        "deliveryType": "scheduled",
        "scheduleName": "Stress",
        "rate": 1.05
    },
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "guid": "f9623fae-217c-47e1-a49c-85b7a9bca8ac",
    "id": "ba1027905672484babe56579f9291204",
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
    "deliveryType": "suspend",
    "duration": 86400000,
    "expectedDuration": 103680000,
    "suppressed": {
        "type": "basal",
        "deliveryType": "scheduled",
        "scheduleName": "Very Active",
        "rate": 1.55
    },
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
    "deliveryType": "suspend",
    "duration": 34200000,
    "expectedDuration": 41040000,
    "suppressed": {
        "type": "basal",
        "deliveryType": "scheduled",
        "scheduleName": "Weekday",
        "rate": 1.525
    },
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:00:05.000Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "guid": "f96df9f8-40f4-4f05-a4d4-c27af663ec2e",
    "id": "76b597d3d2354902b6dcd924d58fbd37",
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
* [Pump settings](./device-data/data-types/pump-settings.md)
* [Scheduled basals](./device-data/data-types/basal/scheduled.md)
* [Suppressed basals](./device-data/data-types/basal/suppressed.md)
* [Temporary basals](./device-data/data-types/basal/temp.md)
* [Units](./device-data/units.md)