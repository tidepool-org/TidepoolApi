<!-- omit in toc -->
# Combination Bolus (`combination`)

<!-- omit in toc -->
## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Sub-Type (`subType`)](#sub-type-subtype)
3. [Examples](#examples)
4. [Keep Reading](#keep-reading)

---

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../../reference/data/models/bolus/combination.v1.yaml"
  }
/%}

---

## Sub-Type (`subType`)

This is the sub-type of bolus event that represents a bolus insulin dose programmed to deliver part of the dose immediatley (a normal bolus) and the remainder delivered evenly over a duration of time (an extended bolus). Essentially, this sub-type is a combination of both normal and extended boluses.

Most insulin pumps ask the user to divide the normal and extended portions of a combination bolus by percentage of the total insulin dose. Tidepool does not save this percentage directly but it can be worked out by looking at the appropriate combination and sum of values (e.g. normal, extended, expected normal and expected extended fields).

---

## Examples

```json {% title="Example (client)" %}
{
    "type": "bolus",
    "subType": "dual/square",
    "normal": 6.25,
    "extended": 5.75,
    "expectedExtended": 8.625,
    "duration": 23400000,
    "expectedDuration": 35100000,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "guid": "dc114f19-74fe-4075-9676-38faec7cf0cc",
    "id": "d184a41eaf984afcbe553071f80bcdec",
    "time": "2018-05-14T08:17:07.035Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json {% title="Example (ingestion)" %}
{
    "type": "bolus",
    "subType": "dual/square",
    "normal": 9.25,
    "extended": 5.5,
    "expectedExtended": 8.25,
    "duration": 57600000,
    "expectedDuration": 86400000,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "time": "2018-05-14T08:17:07.035Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json {% title="Example (storage)" %}
{
    "type": "bolus",
    "subType": "dual/square",
    "normal": 2.25,
    "extended": 9.5,
    "expectedExtended": 14.25,
    "duration": 48600000,
    "expectedDuration": 72900000,
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:12.035Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "guid": "cf850a7a-1f28-4bbc-8a56-36cbe0326f20",
    "id": "4f8b8b133b22401aa1f281be9eb954ad",
    "time": "2018-05-14T08:17:07.035Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Bolus](../bolus.md)
* [Common Fields](../../common-fields.md)
* [Automated Bolus](./automated.md)
* [Extended Bolus](./extended.md)
* [Normal Bolus](./normal.md)
* [Pump Settings](../pump-settings.md)
* [Units](../../units.md)
