# Blood Ketones (`bloodKetone`)<!-- omit in toc -->

## Table of Contents<!-- omit in toc -->

1. [Quick Summary](#quick-summary)
2. [Type (`type`)](#type-type)
3. [Value (`value`)](#value-value)
4. [Examples](#examples)
5. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../reference/data/models/blood/ketone.v1.yaml'
```

---

## Type (`type`)

Blood ketones represent ketone concentration values (specifically beta-ketones) obtained from a fingerstick meter capable of reading specialized blood ketone testing strips. Tidepool does not yet provide a data model for urine ketones, which are measured qualitatively, not quantitatively.

---

## Value (`value`)

Tidepool has used the most popular blood ketone meter on the American market — the Abbott Precision Xtra — as a guide to choose 10.0 mmol/L as the maximum value that will be accepted by Platform. (The Abbott Precision Xtra yields HI for blood ketone values higher than 8.0 mmol/L.)

---

## Examples

```json title="Example (client)" lineNumbers=true
{
    "type": "bloodKetone",
    "units": "mmol/L",
    "value": 4.2,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "guid": "14e3eca2-3e38-41f9-83ce-76ec01300b85",
    "id": "7f856a61e20045d1a8b6e0c4ada4ce69",
    "time": "2018-05-14T08:17:07.211Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json title="Example (ingestion)" lineNumbers=true
{
    "type": "bloodKetone",
    "units": "mmol/L",
    "value": 4.6,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "time": "2018-05-14T08:17:07.212Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json title="Example (storage)" lineNumbers=true
{
    "type": "bloodKetone",
    "units": "mmol/L",
    "value": 0.5,
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:12.212Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "guid": "602c5ebf-fd85-4972-b874-3d6f13d88166",
    "id": "38f80bd338e54522870c9ff8cf5f375d",
    "time": "2018-05-14T08:17:07.212Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Annotations](../annotations.md)
* [Common Fields](../common-fields.md)
* [Out Of Range Values](../oor-values.md)
* [Units](../units.md)
