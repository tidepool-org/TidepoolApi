<!-- omit in toc -->
# Device Delivery Status (`status`)

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../../reference/data/models/deviceevent/deliverystatus.v1.yaml"
  }
/%}

---

## Sub-Type (`subType`)

This is the Tidepool data type for an insulin pump's insulin delivery status. This is used to represent suspensions of insulin delivery — intervals of time when neither bolus or basal insulin is delivered by an insulin pump. When a user suspends an insulin pump or the pump suspends itself automatically, any bolus currently in progress is terminated and the basal insulin is stopped.

In the same way that suspensions of insulin delivery can be either manual or automatic, the resumption of insulin delivery can be the result of automatic or user action.

---

## Duration (`duration`)

The duration field is required on all status events. Platform will determine the duration of suspensions of insulin delivery based on the sequence of suspend and resume events.

There is no maximum duration for suspensions of insulin delivery because there is no maximum value of this in reality. For example, a user may switch between different insulin delivery devices or go on a "pump vacation", thererfore leaving a particular device in the suspended mode for an arbitrary duration of time counted in days, weeks, or even months.

---

## Expected duration (`expectedDuration`)

Most insulin delivery devices do not provide an interface for scheduling suspensions of insulin delivery, so the pump automatically resumes after the scheduled time period. However, the Insulet OmniPod insulin delivery system does provide an interface of this kind. It is only for an OmniPod system that it is possible — though still optional — for an expected duration field to appear. When this field is present, the value of expected duration is the *original* user-programmed duration for the suspension of insulin delivery.

The duration of the event will have a smaller value representing the *actual* elapsed time of the suspension, which must have been canceled by the user prior to its scheduled conclusion.

<!-- theme: info -->

> To change the date & time on an OmniPod system, it is necessary to suspend the device. This is one common workflow that results in the early cancelation of a scheduled suspension of insulin delivery.

---

## Reason (`reason`)

The reason is a simplified indication of why the pump delivery status changed, both on suspension and resumption of insulin delivery.

When pushing up data through Platform, the reason object should include both the suspended and resumed keys with possible manual and automatic values for each.

We define manual suspension or resumption as any user-initiated method of effecting these states, and we define automatic as anything not user-initiated. One type of automatic suspension  occurs on insulin pumps that include a low-glucose suspend feature (LGS). This involves the pump "listening" to data from a blood glucose sensor (i.e. CBG data) and suspending insulin delivery if the blood glucose values either drop below a certain threshold, or are predicted to soon drop below the threshold. The insulin delivery device may also automatically resume from the suspended state in response to rising blood glucose values or after a certain amount of time has elapsed.

We also include more device-specific information about the cause of suspensions and resumptions, if available, in the optional payload embedded object on the event.

For example, in the case of the Medtronic 530G insulin pumps with the LGS feature, there is a distinction in circumstances when determing whether or not a temp basal that was in effect *before* the automatic suspension is resumed. If the user *did not* interact with any of the alerts during the automatic suspension, the temp basal does not resume. If the user *did* acknowledge the automatic suspension, a temp basal is resumed at the conclusion of two hours of suspension. This is explained on pages 124–125 of the [Medtronic 530G user manual](https://www.accessdata.fda.gov/cdrh_docs/pdf12/p120010c.pdf).

We represent this distinction on the event in the payload as follows (specifically in the user intervention key under resumed):

```json lineNumbers=true
{
    ...
    "reason": {
        "suspended": "automatic",
        "resumed": "automatic"
    },
    "payload": {
        "suspended": {
            "cause": "low_glucose",
            "threshold": 80
        },
        "resumed": {
            "cause": "timed_out",
            "user_intervention": "ignored"
        }
    }
    ...
}
```

---

## Status (`status`)

An insulin pump can only be in one of two insulin delivery states: normal operation or suspended.

Platform will only accept a suspended value for the status field.

---

## Examples

```json {% title="Example (client)" %}
{
    "type": "deviceEvent",
    "subType": "status",
    "status": "suspended",
    "duration": 64800000,
    "expectedDuration": 77760000,
    "reason": {
        "suspended": "automatic",
        "resumed": "manual"
    },
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "9f38f6b2-42b0-4194-958c-84efaeb18f3f",
    "id": "eb9ed08320f645c787d892bb75eb7bfd",
    "time": "2018-05-14T08:17:08.634Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json {% title="Example (ingestion)" %}
{
    "type": "deviceEvent",
    "subType": "status",
    "status": "suspended",
    "duration": 77400000,
    "expectedDuration": 92880000,
    "reason": {
        "suspended": "manual",
        "resumed": "manual"
    },
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "time": "2018-05-14T08:17:08.635Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json {% title="Example (storage)" %}
{
    "type": "deviceEvent",
    "subType": "status",
    "status": "suspended",
    "duration": 23400000,
    "expectedDuration": 28080000,
    "reason": {
        "suspended": "automatic",
        "resumed": "manual"
    },
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:13.635Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "a0e4a309-e845-4912-a112-5c71e23da76b",
    "id": "344abda0c652428a8fab0b5fe3153e54",
    "time": "2018-05-14T08:17:08.635Z",
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
* [Reservoir Change](./reservoir-change.md)
* [Time Change](./time-change.md)
