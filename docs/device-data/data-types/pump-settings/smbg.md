# Self-Monitored Blood Glucose (`smbg`)

### Table of Contents

1. [Quick summary](#quick-summary)
2. [Type](#type-type)
3. [Sub-type](#subtype-subtype)
4. [Example (client)](#example-client)
5. [Example (ingestion)](#example-ingestion)
6. [Example (storage)](#example-storage)
7. [Keep reading](#keep-reading)

---

## Quick summary

```json json_schema
{
  "title": "Self-monitored blood glucose (SMBG)",
  "type": "object",
  "properties": {
    "$ref": "../../../../reference/data/models/selfmonitoredglucose.v1.yaml"
  }
}
```

---

## Type (`type`)

This is the Tidepool data type for traditional fingerstick blood glucose meter data. SMBG is an abbreviation of "self-monitored blood glucose" and contrasts with CBG, abbreviating "continuous blood glucose." CBG is the [Tidepool data type for continuous glucose monitor](./device-data/data-types/cgm-settings.md) (CGM) sensor data.

---

## Sub-type (`subType`)

Sub-type appears on blood glucose values that are being read from another data source, such as an insulin pump (rather than directly from a traditional fingerstick blood glucose meter).

The value manual indicates that the blood glucose value was manually entered by a user (and is therefore subject to human error).

The linked value indicates that the blood glucose value was transferred from a blood glucose meter to the pump directly via some sort of data transfer or pairing mechanism. If the blood glucose meter in question is also supported by Tidepool Uploader, duplicate records may exist — both read directly from the meter and pulled in as "linked" sub-type records from the insulin pump.

---

## Example (client)

```json
{
    "type": "smbg",
    "subType": "manual",
    "units": "mmol/L",
    "value": 2.331314156239124,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:09",
    "guid": "2e0f1338-1537-414b-baf7-3827b6185f23",
    "id": "d333e9c6af694b63bb2c2cf3595acc65",
    "time": "2018-05-14T08:17:09.177Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (ingestion)

```json
{
    "type": "smbg",
    "subType": "manual",
    "units": "mg/dL",
    "value": 214,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:09",
    "time": "2018-05-14T08:17:09.177Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (storage)

```json
{
    "type": "smbg",
    "subType": "linked",
    "units": "mmol/L",
    "value": 14.0433924173452,
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:14.177Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:09",
    "guid": "2bb717e7-af53-49b1-94b0-1d93c527d9bf",
    "id": "a4f3f4bce5724070bb1bd9a99ed88d35",
    "time": "2018-05-14T08:17:09.177Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

### Keep reading

* [Bolus calculator](./device-data/data-types/pump-settings/calculator.md)
* [Common fields](./device-data/common-fields.md)
* [Datetime guide](./datetime.md)
* [Diabetes data types](./device-data/data-types.md)
* [Pump settings](./device-data/data-types/pump-settings.md)
* [Units](./device-data/units.md)
* [Upload metadata](./device-data/data-types/pump-settings/upload.md)
