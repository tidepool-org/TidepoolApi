<!-- omit in toc -->
# Suspend Basals (`suspend`)

## Delivery Type (`deliveryType`)

The string `suspend`.

This is the sub-type of basal event representing the total suspension of insulin delivery on a pump within the stream of basal events — which should be without gaps or overlaps. The user's inputs to suspend (and later resume) insulin delivery are part of Tidepool's [device event](../device-event.md) data type. We represent suspend intervals as a suspend basal to maintain a continuous stream of basal data, making the calculation of statistics (e.g. total basal dose per day) easier.

No rate field appears on suspend basal events. The rate is always zero, so this is redundant information.

{% partial file="/_partials/basal_duration.md" /%}

## Suppressed (`suppressed`)

An object representing another `basal` event - namely, the event that is currently [suppressed](./suppressed.md) (inactive) because this suspended basal is in effect.

---

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../../reference/data/models/basal/suspend.v1.yaml"
  }
/%}

---

## Examples

```json {% title="Example (client)" %}
{
    "type": "basal",
    "deliveryType": "suspend",
    "duration": 10800000,
    "expectedDuration": 12960000,
    "suppressed": {
        "type": "basal",
        "deliveryType": "scheduled",
        "scheduleName": "Stress",
        "rate": 1.05
    },
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "guid": "f9623fae-217c-47e1-a49c-85b7a9bca8ac",
    "id": "ba1027905672484babe56579f9291204",
    "time": "2018-05-14T08:00:00.000Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json {% title="Example (ingestion)" %}
{
    "type": "basal",
    "deliveryType": "suspend",
    "duration": 86400000,
    "expectedDuration": 103680000,
    "suppressed": {
        "type": "basal",
        "deliveryType": "scheduled",
        "scheduleName": "Very Active",
        "rate": 1.55
    },
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
    "deliveryType": "suspend",
    "duration": 34200000,
    "expectedDuration": 41040000,
    "suppressed": {
        "type": "basal",
        "deliveryType": "scheduled",
        "scheduleName": "Weekday",
        "rate": 1.525
    },
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:00:05.000Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "guid": "f96df9f8-40f4-4f05-a4d4-c27af663ec2e",
    "id": "76b597d3d2354902b6dcd924d58fbd37",
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
* [Scheduled Basals](./scheduled.md)
* [Suppressed Basals](./suppressed.md)
* [Temporary Basals](./temp.md)
* [Units](../../units.md)
