<!-- omit in toc -->
# Continuous Blood Glucose (`cbg`)

<!-- omit in toc -->
## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Type (`type`)](#type-type)
3. [Examples](#examples)
4. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../reference/data/models/blood/continuousglucose.v1.yaml'
```

---

## Type (`type`)

This is the Tidepool data type for continuous glucose monitor sensor data. "CBG" is an abbreviation of "continuous blood glucose" and contrasts with "SMBG," abbreviating "self-monitored blood glucose." SMBG is the Tidepool data type for traditional fingerstick blood glucose meter data.

The device time field is only optional for *this* data type. This is because Tidepool is now ingesting Dexcom G5 and G6 data via integration with Apple's HealthKit, which only stores a UTC-anchored timestamp and does not have "receiver display time" like earlier generations of Dexcom devices.

---

## Sample Interval (`sampleInterval`)

With the latest generation of continuous glucose monitors, different devices may support different intervals between samples. For example, every 5 minutes or every 15 minutes between samples. In fact, some newer devices may even report multiple sample intervals from different data streams. For example, a device that reports data from both 1-minute samples and 5-minutes samples. 

In order to distinguish between sample intervals and to assist with accurate statisitical calculations, the `sampleInterval` must be specified. The value must be an integer representing number of milliseconds between samples for the data stream that this datum belongs to. For example, if a device reports both 1-minute and 5-minute sample data, then the upload would contain some `cbg` data with a sample interval of 60000 (milliseconds in 1-minute) and others with a sample interval of 300000 (milliseconds in 5-minutes). The typical sample intervals are 60000 (milliseconds in 1 minute), 300000 (milliseconds in 5 minutes), and 1500000 (milliseconds in 15 minutes).

While this field and value are currently optional in the API implementation, this field will be required in the relatively near future (as of 2025-02-07), so it is marked as such here.

---

## Backfilled (`backfilled`)

The backfilled field, an optional boolean, is used to indicate whether this datum was backfilled from the continuous glucose monitor sensor to the device capturing the data. For example, if the CGM sensor is out-of-range of the mobile phone capturing the data, then when the CGM sensor comes back in-range of the mobile phone, the historic sensor data (while the CGM sensor was out-of-range) is "backfilled" to the mobile phone. If it is definitively known that this datum was indeed backfilled, then this field should be set to `true`. If it is definitely known that this datum was **not** backfilled, then this field should be set to `false`. If it is not definitely known one-way-or-the-other, then this field should **not** be specified.

While this value is optional, this field will actively be used in the relatively near future (as of 2025-02-07), so it is highly recommended to support this field as soon as possible, assuming definitive information regarding backfill is available from the device.

---

## Examples

```json title="Example (client)" lineNumbers=true
{
    "type": "cbg",
    "units": "mmol/L",
    "value": 3.996538553552784,
    "sampleInterval": 300000,
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

```json title="Example (ingestion)" lineNumbers=true
{
    "type": "cbg",
    "units": "mg/dL",
    "value": 421,
    "sampleInterval": 60000,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "time": "2018-05-14T08:17:07.385Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json title="Example (storage)" lineNumbers=true
{
    "type": "cbg",
    "units": "mmol/L",
    "value": 27.25417263603357,
    "sampleInterval": 300000,
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

* [Annotations](../annotations.md)
* [CGM Settings](./cgm-settings.md)
* [Common Fields](../common-fields.md)
* [Pump Settings](./pump-settings.md)
* [Self-Monitored Glucose (SMBG)](./smbg.md)
* [Units](../units.md)
