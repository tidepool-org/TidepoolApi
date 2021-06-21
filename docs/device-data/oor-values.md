# Out of Range Values

### Table of Contents

1. [Overview](#overview)
2. [Out of range annotation: units](#out-of-range-annotation-units)
3. [Range threshold levels](#range-threshold-levels)
4. [Keep reading](#keep-reading)

---

## Overview

Blood glucose meters, ketone meters and continuous glucose monitors have a range within which they can measure levels. When a reading falls outside of this range, we need a mechanism to show that we have received an out of range reading. This is done by creating a CBG, SMBG or blood ketone reading with a value that is 1 unit over or below the range threshold, and then annotating the reading.

For example, for a low CGM reading for a device that displays in mg/dL with a low threshold of 40 mg/dL:

```json
{
  "type": "cbg",
  "units": "mg/dL",
  "value": 39,
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2016-06-13T19:05:43",
  "guid": "cf64b6f6-54af-4e8b-a432-08d53c2484d4",
  "id": "da34f6f278984ae385c91cac6b91eff7",
  "time": "2016-06-14T02:05:43.959Z",
  "timezoneOffset": -420,
  "uploadId": "SampleUploadId",
  "annotations": [{
    "code": "bg/out-of-range",
    "value": "low",
    "threshold": 40,
  }]
}
```

---

## Out of range annotation: units

Unlike all other data model types, the out of range annotation does not currently include a field for units. Because of this, when annotating CBG or SMBG readings, the threshold should *always* be in mg/dL, even when the device displays readings in mmol/L. Although an unfortunate oversight, the reason for this is that all devices (that Tidepool knows of) store readings in mg/dL, even if they display in mmol/L.

For blood ketone readings, the threshold should be a value measured in mmol/L. We acknowledge that this is inconvenient and inconsistent with the rest of our data model, and hope to address it in the future by adding a units field, similar to the field used in the CBG, SMBG and blood ketone data types.

For example, for a high CGM reading for a device that displays in mmol/L with a high threshold of 23.0 mmol/L:

```json
{
  "type": "cbg",
  "units": "mmol/L",
  "value": 23.035604162838963,
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2016-06-13T19:05:43",
  "guid": "cf64b6f6-54af-4e8b-a432-08d53c2484d4",
  "id": "da34f6f278984ae385c91cac6b91eff7",
  "time": "2016-06-14T02:05:43.959Z",
  "timezoneOffset": -420,
  "uploadId": "SampleUploadId",
  "annotations": [{
    "code": "bg/out-of-range",
    "value": "high",
    "threshold": 414,
  }]
}
```

---

## Range threshold levels

If the device (or manufacturer) does not provide the exact threshold levels, then the threshold field should *not* be provided, and an additional `[datatype]/unknown-value` annotation should be provided. This is the case in our current Abbott Precision Xtra driver for ketone readings:

```json
{
  "type": "bloodKetone",
  "units": "mmol/L",
  "value": 10.0,
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2016-06-13T19:05:43",
  "guid": "ae40651d-b8e7-428e-840f-bbb3e1132569",
  "id": "55346384504b4b76b24c60a236448012",
  "time": "2016-06-14T02:05:43.500Z",
  "timezoneOffset": -420,
  "uploadId": "SampleUploadId",
  "annotations": [{
      "code": "ketone/out-of-range",
      "value": "high"
    },
    {
      "code": "ketone/unknown-value"
    }
  ]
}
```

In this instance, because the threshold was unknown, we used a value that we knew was out of the meter's range.

---

### Keep reading

* [Blood ketones](./device-data/data-types/blood-ketones.md)
* [Continuous blood glucose (CBG)](./device-data/data-types/cbg.md)
* [CGM settings](./device-data/data-types/cgm-settings.md)
* [Self-monitored glucose (SMBG)](./device/data/data-types/pump-settings/smbg.md)