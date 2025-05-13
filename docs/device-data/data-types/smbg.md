<!-- omit in toc -->
# Self-Monitored Blood Glucose (`smbg`)

<!-- omit in toc -->
## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Type (`type`)](#type-type)
3. [Sub-Type (`subType`)](#sub-type-subtype)
4. [Examples](#examples)
5. [Keep Reading](#keep-reading)

---

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../reference/data/models/blood/selfmonitoredglucose.v1.yaml"
  }
/%}

---

## Type (`type`)

This is the Tidepool data type for traditional fingerstick blood glucose meter data. SMBG is an abbreviation of "self-monitored blood glucose" and contrasts with CBG, abbreviating "continuous blood glucose." CBG is the [Tidepool data type for continuous glucose monitor](./cgm-settings.md) (CGM) sensor data.

---

## Sub-Type (`subType`)

Sub-type appears on blood glucose values that are being read from another data source, such as an insulin pump (rather than directly from a traditional fingerstick blood glucose meter).

The value manual indicates that the blood glucose value was manually entered by a user (and is therefore subject to human error).

The linked value indicates that the blood glucose value was transferred from a blood glucose meter to the pump directly via some sort of data transfer or pairing mechanism. If the blood glucose meter in question is also supported by Tidepool Uploader, duplicate records may exist — both read directly from the meter and pulled in as "linked" sub-type records from the insulin pump.

---

## Examples

```json {% title="Example (client)" %}
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

```json {% title="Example (ingestion)" %}
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

```json {% title="Example (storage)" %}
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

## Keep Reading

* [Bolus Calculator](./calculator.md)
* [Common Fields](../common-fields.md)
* [Datetime Guide](../../datetime.md)
* [Diabetes Data Types](../data-types.md)
* [Pump Settings](./pump-settings.md)
* [Units](../units.md)
* [Upload Metadata](./upload.md)
