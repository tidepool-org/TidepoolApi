# Automated Bolus (`automated`)

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
$ref: '../../../../reference/data/models/bolus/automated.v1.yaml'
```

---

## Sub-Type (`subType`)

This is the sub-type of bolus event that represents a bolus insulin dose delivered within a matter of seconds or a small number of minutes (depending on the insulin pump and the user's settings). At Tidepool, we follow the common convention of representing automated boluses as point-in-time events since their durations are so short.

---

## Example (client)

```json
{
    "type": "bolus",
    "subType": "automated",
    "normal": 7.75,
    "expectedNormal": 9.3,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:06",
    "guid": "3645b635-e97a-410b-b866-5ccc8cb98cbf",
    "id": "622cc9f88a61475f8a1290909ec56e5c",
    "time": "2018-05-14T08:17:06.676Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (ingestion)

```json
{
    "type": "bolus",
    "subType": "automated",
    "normal": 4.5,
    "expectedNormal": 5.4,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:06",
    "time": "2018-05-14T08:17:06.676Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (storage)

```json
{
    "type": "bolus",
    "subType": "automated",
    "normal": 8.25,
    "expectedNormal": 9.9,
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:11.676Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:06",
    "guid": "5f7a9c48-ec16-449c-9597-2cef1f679096",
    "id": "8480f23a08484c91a7436475ee40c0c6",
    "time": "2018-05-14T08:17:06.676Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Bolus](./device-data/data-types/bolus.md)
* [Combination Bolus](./device-data/data-types/bolus/combination.md)
* [Common Fields](./device-data/common-fields.md)
* [Extended Bolus](./device-data/data-types/bolus/extended.md)
* [Normal Bolus](./device-data/data-types/bolus/normal.md)
* [Pump Settings](./device-data/data-types/pump-settings.md)
* [Units](./device-data/units.md)
