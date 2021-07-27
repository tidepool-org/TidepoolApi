# Continuous Blood Glucose (`cbg`)

## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Type](#type-type)
3. [Example (client)](#example-client)
4. [Example (ingestion)](#example-ingestion)
5. [Example (storage)](#example-storage)
6. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../reference/data/models/blood/continuousglucose.v1.yaml'
```

---

## Type (`type`)

This is the Tidepool data type for continuous glucose monitor sensor data. "CBG" is an abbreviation of "continuous blood glucose" and contrasts with "SMBG," abbreviating "self-monitored blood glucose." SMBG is the Tidepool data type for traditional fingerstick blood glucose meter data.

The device time field is only optional for *this* data type. This is because Tidepool is now ingesting Dexcom G5 data via integration with Apple's HealthKit, which only stores a UTC-anchored timestamp and does not have "reciever display time" like earlier generations of Dexcom devices.

---

## Example (client)

```json
{
    "type": "cbg",
    "units": "mmol/L",
    "value": 3.996538553552784,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "guid": "82bd8ef1-cfa1-4b49-9230-e2cecac7c5cd",
    "id": "b8858168bd4e447184ee7c7743ffe303",
    "time": "2018-05-14T08:17:07.384Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (ingestion)

```json
{
    "type": "cbg",
    "units": "mg/dL",
    "value": 421,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "time": "2018-05-14T08:17:07.385Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (storage)

```json
{
    "type": "cbg",
    "units": "mmol/L",
    "value": 27.25417263603357,
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:12.385Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "guid": "6ad8322a-e29d-4db7-825f-e0ad4c45d723",
    "id": "7779ad3759b14d1fadda7b5bab6d79bd",
    "time": "2018-05-14T08:17:07.385Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Annotations](./device-data/annotations.md)
* [CGM Settings](./device-data/data-types/cgm-settings.md)
* [Common Fields](./device-data/common-fields.md)
* [Pump Settings](./device-data/data-types/pump-settings.md)
* [Self-Monitored Glucose (SMBG)](./device-data/data-types/pump-settings/smbg.md)
* [Units](./device-data/units.md)
