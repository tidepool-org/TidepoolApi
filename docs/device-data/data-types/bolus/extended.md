# Extended Bolus (`extended`)

## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Sub-Type](#sub-type-subtype)
3. [Example (client)](#example-client)
4. [Example (ingestion)](#example-ingestion)
5. [Example (storage)](#example-storage)
6. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../../reference/data/models/bolus/extended.v1.yaml'
```

---

## Sub-Type (`subType`)

This is the sub-type of bolus event that represents a bolus insulin dose programmed to be delivered evenly over a duration of time (typically 15 minutes to several hours).

---

## Example (client)

```json
{
    "type": "bolus",
    "subType": "square",
    "extended": 9.75,
    "expectedExtended": 14.625,
    "duration": 3600000,
    "expectedDuration": 5400000,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:06",
    "guid": "05934ef2-230c-42cb-bebc-e2163462dbf7",
    "id": "5753389d95f842c283de92bb85ca43cf",
    "time": "2018-05-14T08:17:06.859Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (ingestion)

```json
{
    "type": "bolus",
    "subType": "square",
    "extended": 8.25,
    "expectedExtended": 12.375,
    "duration": 25200000,
    "expectedDuration": 37800000,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:06",
    "time": "2018-05-14T08:17:06.860Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (storage)

```json
{
    "type": "bolus",
    "subType": "square",
    "extended": 6,
    "expectedExtended": 9,
    "duration": 23400000,
    "expectedDuration": 35100000,
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:11.860Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:06",
    "guid": "23f71af0-f30b-4348-88f6-4169bd46ffcb",
    "id": "b862128865b34aabad71d02389717579",
    "time": "2018-05-14T08:17:06.860Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Automated Bolus](./device-data/data-types/bolus/automated.md)
* [Bolus](./device-data/data-types/bolus.md)
* [Combination Bolus](./device-data/data-types/bolus/combination.md)
* [Common Fields](./device-data/common-fields.md)
* [Normal Bolus](./device-data/data-types/bolus/normal.md)
* [Pump Settings](./device-data/data-types/pump-settings.md)
* [Units](./device-data/units.md)
