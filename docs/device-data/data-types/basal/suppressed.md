# Suppressed Basals (`suppressed`)<!-- omit in toc -->

## Table of Contents<!-- omit in toc -->

1. [Quick Summary: scheduled](#quick-summary-scheduled)
2. [Quick Summary: automated](#quick-summary-automated)
3. [Quick Summary: temporary](#quick-summary-temporary)
4. [Overview](#overview)
5. [Suppressed Across Schedule Boundaries](#suppressed-across-schedule-boundaries)
6. [Suppressed: When A Temp Or Suspend Is Edited](#suppressed-when-a-temp-or-suspend-is-edited)
7. [Nested Suppressed In Suspend Basals](#nested-suppressed-in-suspend-basals)
8. [Suppressed Suspend Basals](#suppressed-suspend-basals)
9. [Keep Reading](#keep-reading)

---

## Quick Summary: scheduled

```yaml json_schema
$ref: '../../../../reference/data/models/basal/suppressed/scheduled.v1.yaml'
```

---

## Quick Summary: automated

```yaml json_schema
$ref: '../../../../reference/data/models/basal/suppressed/automated.v1.yaml'
```

---

## Quick Summary: temporary

```yaml json_schema
$ref: '../../../../reference/data/models/basal/suppressed/temporary.v1.yaml'
```

---

## Overview

A suppressed basal is a way to essentially replace one basal with another basal. For example, if a PwD's blood glucose is falling, they may program a temp basal to try and prevent hypoglycemia. By programming a temp basal, they are suppressing a scheduled basal, which was previously in effect. A suppressed can apply to all basal types except a suspend — [see here](#suppressed-suspend-basals).

A suppressed may contain the following properties:

* Type
* Delivery type
* Rate
* Schedule name (optional)

Some insulin pump data protocols let us track various aspects of the basal that *would have occurred* if uninterrupted by the current active temp or suspend basal. Where available, we provide this information as an embedded object in the suppressed field on a temp or suspend basal interval.

If the current active basal is a suspend and the suppressed is a temp, then the following temp fields may also be present on the suppressed object:

* [Percent](./temp.md#percent-percent)
* [Nested Suppressed Object](#nested-suppressed-in-suspend-basals)

<!-- theme: warning -->

> We do *not* include any timestamp or duration information in the suppressed — these values are always equal to those of the active basal intervals, so it is unnecessary to specify them.

---

## Suppressed Across Schedule Boundaries

When a temp or suspend basal crosses a basal schedule boundary, the original programmed basal rate *changes* in accordance with the schedule change. This necessitates splitting the temp or suspend into multiple segments: each type of basal; the sum of all segments' durations; and the total duration of the temp or suspend (as reported by the insulin pump).

For example, let us assume this basal schedule is active:

```json lineNumbers=true
[
  {
    "start": 0, // midnight
    "rate": 0.25
  },
  {
    "start": 3600000, // 1 a.m.
    "rate": 0.2
  },
  {
    "start": 10800000, // 3 a.m.
    "rate": 0.25
  },
  {
    "start": 21600000, // 6 a.m.
    "rate": 0.6
  },
  {
    "start": 43200000, // 12 p.m.
    "rate": 0.35
  }
]
```

A scheduled basal event on a particular day at 12:00 am — according to this schedule —  would look like:

```json lineNumbers=true
{
  "type": "basal",
  "deliveryType": "scheduled",
  "duration": 3600000,
  "rate": 0.25,
  "scheduleName": "Standard",
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2016-10-07T00:00:00",
  "time": "2016-10-07T07:00:00.000Z",
  "timezoneOffset": -420,
  "uploadId": "SampleUploadId"
}
```

Now, let's say a user programs a temp basal at 12:25 am to run for three hours, until 3:25 am. The scheduled basal will look almost the same, except the duration will be different since the scheduled segment will have only run for 25 minutes from 12:00 am to 12:25 am:

```json lineNumbers=true
{
  "type": "basal",
  "deliveryType": "scheduled",
  "duration": 1500000, // 25 minutes from 12:00 a.m. to 12:25 a.m.
  "rate": 0.25,
  "scheduleName": "Standard",
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2016-10-07T00:00:00",
  "time": "2016-10-07T07:00:00.000Z",
  "timezoneOffset": -420,
  "uploadId": "SampleUploadId"
}
```

The three-hour temp basal will cross schedule boundaries at 1:00 am and 3:00 am. It will then be divided into three segment intervals, with the suppressed field matching the segment of the schedule that *would have occurred* if the temp had not been programmed.

First temp interval:

```json lineNumbers=true
{
  "type": "basal",
  "deliveryType": "temp",
  "duration": 2100000, // 35 minutes from 12:25 a.m. to 1:00 a.m.
  "percent": 0.5,
  "rate": 0.125, // == percent * suppressed.rate
  "suppressed": {
    "type": "basal",
    "deliveryType": "scheduled",
    "rate": "0.25",
    "scheduleName": "Standard"
  },
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2016-10-07T00:25:00",
  "time": "2016-10-07T07:25:00.000Z",
  "timezoneOffset": -420,
  "uploadId": "SampleUploadId"
}
```

Second temp interval:

```json lineNumbers=true
{
  "type": "basal",
  "deliveryType": "temp",
  "duration": 7200000, // 2 hours from 1:00 a.m. to 3:00 a.m.
  "percent": 0.5,
  "rate": 0.1, // == percent * suppressed.rate
  "suppressed": {
    "type": "basal",
    "deliveryType": "scheduled",
    "rate": "0.2",
    "scheduleName": "Standard"
  },
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2016-10-07T01:00:00",
  "time": "2016-10-07T08:00:00.000Z",
  "timezoneOffset": -420,
  "uploadId": "SampleUploadId"
}
```

Third temp interval:

```json lineNumbers=true
{
  "type": "basal",
  "deliveryType": "temp",
  "duration": 1500000, // 25 minutes from 3:00 a.m. to 3:25 a.m.
  "percent": 0.5,
  "rate": 0.125, // == percent * suppressed.rate
  "suppressed": {
    "type": "basal",
    "deliveryType": "scheduled",
    "rate": "0.25",
    "scheduleName": "Standard"
  },
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2016-10-07T03:00:00",
  "time": "2016-10-07T10:00:00.000Z",
  "timezoneOffset": -420,
  "uploadId": "SampleUploadId"
}
```

The durations of all three temp intervals here adds up to the programmed temp duration: 2100000 + 7200000 + 1500000 = 10800000 (three hours).

For a suspend that crosses scheduled boundaries, the examples would be very similar, except with no rate on the top-level (active) suspend basal.

<!-- theme: warning -->

> A known issue with this data model is that when a temp or suspend basal crosses *more than one* schedule boundary, but then is cancelled within one of the "middle" (not edge) segments, we have no good way to represent the original expected duration of the *entire* programmed temp or suspend. The expected duration on a middle segment of a three-or-more segment temp or suspend basal should be the expected duration of *that segment* from the basal schedule.

---

## Suppressed: When A Temp Or Suspend Is Edited

To date, we know of one insulin pump manufacturer (Medtronic) that allows for *editing* a temp basal while it is in effect. In principle, the same could apply to a suspend programmed with a duration (as required for OmniPod). For the purposes of our temp basal model, we treat the editing of a temp basal as a cancellation, followed by the immediate scheduling of a second temp. We *do not* consider the first temp basal to be suppressed by the second edited temp. For example, consider a user running a "flat rate" basal schedule:

```json lineNumbers=true
[
  {
    "start": 0,
    "rate": 1.95
  }
]
```

At 8:00 am, this user schedules an 85% temp basal to run for four hours, but edits it after three hours and 36 minutes to change the percentage to 90%. The first temp basal event will look like this:

```json lineNumbers=true
{
  "type": "basal",
  "deliveryType": "temp",
  "duration": 12960000,
  "expectedDuration": 14400000,
  "percent": 0.85,
  "rate": 1.6575,
  "suppressed": {
    "type": "basal",
    "deliveryType": "scheduled",
    "scheduleName": "Weekend",
    "rate": 1.95
  },
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2016-10-07T08:00:00",
  "guid": "634b43c7-9d0d-47ed-afec-3aac2db99a6a",
  "id": "9759417fa35c45839d0400240a13523c",
  "time": "2016-10-07T15:00:00.000Z",
  "timezoneOffset": -420,
  "uploadId": "SampleUploadId"
}
```

The second follows immediately,  but carries no indication that it is an "edited" temp (except perhaps additional information in the payload); rather, it is indistinguishable from a "fresh" temp basal scheduled for the given time. Note that its suppressed is the scheduled flat-rate basal, *not* the prior temp basal.

```json lineNumbers=true
{
  "type": "basal",
  "deliveryType": "temp",
  "duration": 1440000,
  "percent": 0.90,
  "rate": 1.755,
  "suppressed": {
    "type": "basal",
    "deliveryType": "scheduled",
    "scheduleName": "Weekend",
    "rate": 1.95
  },
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2016-10-07T11:36:00",
  "guid": "634b43c7-9d0d-47ed-afec-3aac2db99a6a",
  "id": "9759417fa35c45839d0400240a13523c",
  "time": "2016-10-07T18:36:00.000Z",
  "timezoneOffset": -420,
  "uploadId": "SampleUploadId"
}
```

---

## Nested Suppressed In Suspend Basals

Because a suspend can occur when a temp is in effect, there is the possibility of **nested** suppressed in a suspend basal. The suppressed on the suspend basal contains information about the temp that was in effect *before* the suspend was programmed or triggered.

In addition to the suppressed  (about the temp) on the active suspend, the suppressed temp can *also* have a suppressed containing information about the scheduled basal that *would have occurred* had the temp basal not been programmed. For example:

```json lineNumbers=true
{
  "type": "basal",
  "deliveryType": "suspend",
  "duration": 41400000,
  "suppressed": {
    "type": "basal",
    "deliveryType": "temp",
    "percent": 0.5,
    "rate": 0.6,
    "suppressed": {
      "type": "basal",
      "deliveryType": "scheduled",
      "scheduleName": "Very Active",
      "rate": 1.2
    }
  },
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2016-10-09T23:00:00",
  "guid": "58812f26-e734-4b9a-9162-02bfee2a1dce",
  "id": "a428262a0f7245a792db5712dc11d6eb",
  "time": "2016-10-10T06:00:00.000Z",
  "timezoneOffset": -420,
  "uploadId": "SampleUploadId"
}
```

Just as with a single level of suppressed, nested suppressed should be adjusted whenever the basal crosses a schedule boundary.

---

## Suppressed Suspend Basals

A suspend basal can embed a scheduled, automatic or temporary suppressed basal, *even if that basal already contains a suppressed basal event*. For example:

* A user's blood glucose is falling and they program a temp basal (which embeds a suppressed scheduled basal) in an attempt to prevent hypoglycemia
* However, the user's blood glucose continues to fall and the insulin pump suspends insulin delivery (due to the automatic low glucose suspend feauture)
* This creates a suspend basal that embeds a suppressed temp basal, which is still embedding a suppressed scheduled basal

---

## Keep Reading

* [Basal](../basal.md)
* [Common Fields](../../common-fields.md)
* [Pump Settings](../pump-settings.md)
* [Automated Basals](./automated.md)
* [Scheduled Basals](./scheduled.md)
* [Suspend Basals](./suspend.md)
* [Temporary Basals](./temp.md)
* [Units](../../units.md)
