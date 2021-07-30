# Alarm (`alarm`)

## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Sub-Type](#subtype-subtype)
3. [Alarm Types](#alarm-types-alarmtypes)
4. [Status](#status-status)
5. [Example (client)](#example-client)
6. [Example (ingestion)](#example-ingestion)
7. [Example (storage)](#example-storage)
8. [Keep Reading](#keep-reading)

---

## QUick Summary

```yaml json_schema
$ref: '../../../../reference/data/models/devicealarm.v1.yaml'
```

---

## Sub-Type (`subType`)

The alarm sub-type describes alerts and alarms surfaced to the user by insulin pumps and continuous glucose monitors.

---

## Alarm Types (`alarmType`)

The alarm types built into the data model are common alarms to most insulin pumps or continuous glucose monitors. At present, Tidepool has only modeled the set of alarms for insulin pumps:

* **Auto off :** When an insulin pump stops all insulin delivery due to inactivity for a duration over the user's programmed threshold
* **Low insulin :** Low insulin reservoir alerts and alarms
* **Low power :** Low battery alerts and alarms
* **No delivery :** Alarms signaling any other stoppage of insulin delivery when a more precise cause (such as an occlusion or empty reservoir) is not indicated by the pump
* **No insulin :** Empty insulin reservoir alarms
* **No power :** Dead battery alarms
* **Occlusion :** Alarms regarding blockage of insulin infusion lines or sites
* **Over limit :** When insulin delivery has surpassed any of a user's programmed maximum bolus, basal, or hourly delivery thresholds

Most alarm events include a "payload" object with more device-specific information about the alarm. For example, a low insulin alarm may have a "units left" field in its payload to record the  units of insulin remaining in the  pump's reservoir at the time of the alarm.

A payload object is required when the alarm type is "other", which is the alarm type used for all device-specific alarms. For example, a pod expiration alarm is specific to the Insulet OmniPod insulin delivery system. The payload object should include all information that could be relevant to anyone wishing to audit the history and performance of the insulin pump in question.

<!-- theme: info -->

> Some pumps may use the no delivery alarm for all stoppages of delivery and may not distinguish between empty reservoirs and occlusions.

An alarm event may be the only indication of a suspension of insulin delivery in some devices. In such a case, a status event should also be uploaded to Platform and included (in its entirety) in the status field of the alarm event.

---

## Status (`status`)

Some alarm types are correlated with a stoppage of insulin delivery. Tidepool assumes the following alarms correspond to a period of no insulin delivery on the insulin pump (i.e. the pump's delivery status is suspended):

* Auto off
* No delivery
* No insulin
* No power
* Occlusion

Some insulin pumps include indication of this stoppage both in the alarm event and elsewhere in their data protocols. Other insulin pumps, however, do not separately indicate the change in the pump's insulin delivery status. For such devices, a status event should be fabricated using the relevant information from the alarm event (timestamp, log index, etc.) and then embedded in the originating alarm to preserve the close connection between events. This also provides an audit trail of the user's processed and standardized data.

See [linking events](./device-data/linking-events.md) for additional details regarding inter-event linking in the Tidepool platform.

---

## Example (client)

```json
{
    "type": "deviceEvent",
    "subType": "alarm",
    "alarmType": "occlusion",
    "status": "4907943557f440dfbc12bdef4f85e01c",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "guid": "e3c82e3d-23ba-4048-9056-7b1b3c5aa4cc",
    "id": "d5ed640dd8f74e6cb1a6bff796de3ba2",
    "time": "2018-05-14T08:17:07.920Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (ingestion)

```json
{
    "type": "deviceEvent",
    "subType": "alarm",
    "alarmType": "low_insulin",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "time": "2018-05-14T08:17:07.920Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (storage)

```json
{
    "type": "deviceEvent",
    "subType": "alarm",
    "alarmType": "low_power",
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:12.920Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "guid": "d19fe993-f26e-49d9-ac22-48be650a8e97",
    "id": "a74b59b21581466b9d9f60811d327df2",
    "time": "2018-05-14T08:17:07.920Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Calibration](./device-data/data-types/device-event/calibration.md)
* [Common Fields](./device-data/common-fields.md)
* [Device Event](./device-data/data-types/device-event.md)
* [Linking Events](./device-data/linking-events.md)
* [Prime](./device-data/data-types/device-event/prime.md)
* [Pump Settings](device-data/data-types/pump-settings)
* [Reservoir Change](./device-data/data-types/device-event/reservoir-change.md)
* [Status](./device-data/data-types/device-event/status.md)
* [Time Change](./device-data/data-types/device-event/time-change.md)
