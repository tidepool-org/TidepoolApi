<!-- omit in toc -->
# Prime (`prime`)

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../../reference/data/models/deviceevent/prime.v1.yaml"
  }
/%}

---

## Sub-Type (`subType`)

The prime sub-type of device event represents a user's "priming" of either an insulin infusion line (used with traditional insulin pumps) or an insulin delivery cannula (used in tubeless patch pumps and some traditional pumps).

To "prime" an infusion line or cannula is to fill it with insulin either:

* While disconnected from the user
* Or, in preparation for a site or reservior change

The priming process removes any air from the tubing or cannula to ensure seamless insulin delivery.

---

## Prime Target (`primeTarget`)

The prime target field identifies the object of the priming action — "tubing" for an infusion line prime or "cannula" for a cannula prime.

Most commonly, tubing and cannula prime events will occur as a pair separated only by seconds or minutes. However, many combinations of prime events are possible. For example, no priming events appear in an  OmniPod's data, as the device primes automatically without notifying the user.

Among traditional pump users, priming behavior varies considerably. Those who use steel cannulas must prime the cannula and tubing simultaneously, as the steel cannula and infusion line are inseparable. In this case, only tubing primes will appear in the data. Other insulin pump users can change the infusion site independently (without changing the insulin reservoir), causing a cannula prime to appear *without* a tubing prime.

---

## Volume (`volume`)

Where available in the data, the volume of a priming event should be included to measure insulin expended from the priming action.

---

## Examples

```json {% title="Example (client)" %}
{
    "type": "deviceEvent",
    "subType": "prime",
    "primeTarget": "cannula",
    "volume": "0.5",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "7637c7b9-6286-4f93-8953-d619e42cb1a5",
    "id": "bfc3e597e16c436a94a03d7fd095a774",
    "time": "2018-05-14T08:17:08.276Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json {% title="Example (ingestion)" %}
{
    "type": "deviceEvent",
    "subType": "prime",
    "primeTarget": "tubing",
    "volume": 12,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "time": "2018-05-14T08:17:08.276Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json {% title="Example (storage)" %}
{
    "type": "deviceEvent",
    "subType": "prime",
    "primeTarget": "tubing",
    "volume": 15.3,
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:13.276Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "a6f76c8d-38e5-4c60-96d9-8df53b0fb9e8",
    "id": "94e1776ca9384280bd347691e105b02f",
    "time": "2018-05-14T08:17:08.276Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Alarm](./alarm.md)
* [Calibration](./calibration.md)
* [Common Fields](../../common-fields.md)
* [Device Event](../device-event.md)
* [Pump Settings](../pump-settings.md)
* [Reservoir Change](./reservoir-change.md)
* [Status](./status.md)
* [Time Change](./time-change.md)
