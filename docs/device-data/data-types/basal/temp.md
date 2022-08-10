# Temporary Basals (`temp`)<!-- omit in toc -->

## Table of Contents<!-- omit in toc -->

1. [Quick Summary](#quick-summary)
2. [Delivery Type (`deliveryType`)](#delivery-type-deliverytype)
3. [Percent (`percent`)](#percent-percent)
4. [Examples](#examples)
5. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../../reference/data/models/basal/temporary.v1.yaml'
```

---

## Delivery Type (`deliveryType`)

This is the sub-type of basal event that represents temporary intervals of basal insulin delivery requested by the user. Insulin pumps allow a temporary basal insulin rate for a duration of up to 24 hours. Depending on the pump, the user will be able to program a temp basal rate by percentage, manual specification or both.

---

## Percent (`percent`)

Different insulin pump manufacturers have different interfaces for setting temporary basal rates by percentage. Some express this as a positive or negative percentage from the currently active scheduled basal rate. Other pumps express this change as an absolute percentage of the current active rate.

Examples:

1. The current active rate is 0.5 units per hour, so the user programs a -50% temp basal to implement a rate of 0.25
2. The user inputs 50% to yield  0.25 units per hour and 150% to yield a 0.75 temporary rate

Tidepool's data model has standardized on a floating point representation of the second strategy. The value 0.0 represents a temp basal at 0% of the current active rate, 0.5 at 50%, 1.0 at 100%, 1.5 at 150%, and so on.

---

## Examples

```json title="Example (client)" lineNumbers=true
{
    "type": "basal",
    "deliveryType": "temp",
    "duration": 28800000,
    "expectedDuration": 34560000,
    "percent": 0.75,
    "rate": 0.1875,
    "suppressed": {
        "type": "basal",
        "deliveryType": "scheduled",
        "scheduleName": "Weekend",
        "rate": 0.25
    },
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:00:00",
    "guid": "a58d9efb-3f0d-41d3-a711-edf890a3062e",
    "id": "e52976685fc94f7a9d0272fdd5c63fa0",
    "time": "2018-05-14T08:00:00.000Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json title="Example (ingestion)" lineNumbers=true
{
    "type": "basal",
    "deliveryType": "temp",
    "duration": 50400000,
    "expectedDuration": 60480000,
    "percent": 0.65,
    "rate": 1.2025,
    "suppressed": {
        "type": "basal",
        "deliveryType": "scheduled",
        "scheduleName": "Stress",
        "rate": 1.85
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

```json title="Example (storage)" lineNumbers=true
{
    "type": "basal",
    "deliveryType": "temp",
    "duration": 82800000,
    "expectedDuration": 99360000,
    "percent": 0.75,
    "rate": 0.075,
    "suppressed": {
        "type": "basal",
        "deliveryType": "scheduled",
        "scheduleName": "Very Active",
        "rate": 0.1
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
    "guid": "7a504ee3-17a5-4ec8-b157-c1a985731192",
    "id": "e3b4654d90664fca9a30c20ff19c93fd",
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
* [Suspend Basals](./suspend.md)
* [Units](../../units.md)
