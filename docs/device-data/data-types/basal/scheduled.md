<!-- omit in toc -->
# Scheduled Basals (`scheduled`)

## Delivery Type (`deliveryType`)

The string `scheduled`.

This is the sub-type of basal event that represents intervals of basal insulin delivery triggered by the pump itself according to the active basal schedule programmed by the user (or clinician).

{% partial file="/_partials/basal.md" /%}

{% partial file="/_partials/rate.md" /%}

## Schedule Name (`scheduleName`)

A string: the name of the basal schedule.

Tidepool would love to surface the basal schedule names for every pump manufacturer. Unfortunately, most manufacturers do not provide this information or record pump setting changes. In some cases, we can find this information ourselves by looking up the active pump settings at the time of a particular basal event.

Schedule name is an optional field and should only be added to basal data when directly available from an insulin pump's raw data, or if it can be inferred with high confidence via lookup against a complete pump settings history.

---

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../../reference/data/models/basal/scheduled.v1.yaml"
  }
/%}

---

## Examples

```json {% title="Example (client)" %}
{
    "type": "basal",
    "deliveryType": "scheduled",
    "duration": 84600000,
    "rate": 1.45,
    "scheduleName": "Very Active",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "guid": "9d161801-2607-4cb6-b4f8-457159c7786c",
    "id": "30f76219248d474fa7025b12f0e4b136",
    "time": "2018-05-14T08:00:00.000Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json {% title="Example (ingestion)" %}
{
    "type": "basal",
    "deliveryType": "scheduled",
    "duration": 82800000,
    "rate": 0.025,
    "scheduleName": "Weekend",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "time": "2018-05-14T08:00:00.000Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json {% title="Example (storage)" %}
{
    "type": "basal",
    "deliveryType": "scheduled",
    "duration": 79200000,
    "rate": 1.175,
    "scheduleName": "Vacation",
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:00:05.000Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "guid": "05d3bdbd-3ad3-4762-9a7b-2e8e27a601c3",
    "id": "33f00679ddf440ec95055114162d4821",
    "time": "2018-05-14T08:00:00.000Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Basal](../basal.md)
* [Common Fields](../../common-fields.md)
* [Pump Settings](../pump-settings.md)
* [Automated Basals](./automated.md)
* [Suppressed Basals](./suppressed.md)
* [Suspend Basals](./suspend.md)
* [Temporary Basals](./temp.md)
* [Units](../../units.md)
