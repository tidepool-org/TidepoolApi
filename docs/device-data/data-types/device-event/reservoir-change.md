# Reservoir Change (`reservoirChange`)<!-- omit in toc -->

## Table of Contents<!-- omit in toc -->

1. [Quick Summary](#quick-summary)
2. [Sub-Type (`subType`)](#sub-type-subtype)
3. [Status (`status`)](#status-status)
4. [Examples](#examples)
5. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../../reference/data/models/devicereservoirchange.v1.yaml'
```

---

## Sub-Type (`subType`)

A reservoir change event represents a recent change or refill of the insulin reservoir. Conventional insulin pumps refer to this as a "rewind" event, whereas an Insulet OmniPod system will call this a "deactivation" event.

The optional payload object should include device-specific and event-specific information that is being interpreted more generally as a reservoir change and/or may be desirable for auditing user and device behavior and performance.

---

## Status (`status`)

This event often implies a suspension of insulin delivery. If the device data includes a reservoir change (rewind or deactivation) event but does not include separate indication of insulin delivery suspension, a status event should be uploaded to Platform to record the suspension of insulin delivery. This event should include relevant information from the reservoir change event (e.g. timestamp and log index) and get embedded into the reservoir change event to provide an audit trail of the user's data and to preserve the close connection between the stored events.

See [linking events](../../linking-events.md) for additional details regarding inter-event linking in the Tidepool platform.

---

## Examples

```json title="Example (client)" lineNumbers=true
{
    "type": "deviceEvent",
    "subType": "reservoirChange",
    "status": "e0c1998c36d643d49d09047833064314",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "075b8a5e-4404-4987-8df8-54d2fed20c09",
    "id": "8ce74bae4d294f058bbf96102b6b44f9",
    "time": "2018-05-14T08:17:08.453Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json title="Example (ingestion)" lineNumbers=true
{
    "type": "deviceEvent",
    "subType": "reservoirChange",
    "status": {
        "type": "deviceEvent",
        "subType": "status",
        "status": "suspended",
        "duration": 64800000,
        "expectedDuration": 77760000,
        "reason": {
            "suspended": "manual",
            "resumed": "manual"
        },
        "clockDriftOffset": 0,
        "conversionOffset": 0,
        "deviceId": "DevId0987654321",
        "deviceTime": "2018-05-14T18:17:08",
        "time": "2018-05-14T08:17:08.453Z",
        "timezoneOffset": 600,
        "uploadId": "SampleUploadId"
    },
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "time": "2018-05-14T08:17:08.453Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json title="Example (storage)" lineNumbers=true
{
    "type": "deviceEvent",
    "subType": "reservoirChange",
    "status": "e50c3da3a35e47f2a8ef769406a0805d",
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:13.453Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "96013c51-c2f5-4557-ad0b-479151cf0512",
    "id": "6e3ea4734056463f84f6be47621d21d7",
    "time": "2018-05-14T08:17:08.453Z",
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
* [Linking Events](../../linking-events.md)
* [Prime](./prime.md)
* [Pump Settings](../pump-settings.md)
* [Pump Settings Override](./pump-settings-override.md)
* [Status](./status.md)
* [Time Change](./time-change.md)
