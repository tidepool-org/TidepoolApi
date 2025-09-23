<!-- omit in toc -->
# Alert (`alert`)

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../reference/data/models/alert.v1.yaml"
  }
/%}

---

## Overview

This is the Tidepool data type representing an alert presented to the user from a device or controller.

---

## Type (`type`)

This is the Tidepool data type to represent ab alert presented to the user from a device or controller.

---

## Name (`name`)

The name of the alert, not necessarily human readable. This is not a unique identifier for the alert, but rather a name of the class of alert presented to the user. For example, "CGM.lowGlucose".

## Priority (`priority`)

The priority of the alert. One of `critical`, `normal`, or `timeSensitive`.

## Trigger (`trigger`)

The trigger that causes the alert to be presented. One of `delayed`, `immediate`,  or `repeating`.

## Trigger Delay (`triggerDelay`)

For a `delayed` or `repeating` trigger alert, the delay, in seconds, before the alert is presented after it is initially issued and, for `repeating` trigger alerts, the delay before re-presenting it after it was previously presented.

## Sound (`sound`)

The sound associated with the alert. One of `name`, `silence`, or `vibrate`.

## Sound Name (`soundName`)

For a `name` sound, then name of the sound played when the alert is presented.

## Issued Time (`issuedTime`)

The time the alert was issued (aka created).

## Acknowledged Time (`acknowledgedTime`)

The time the alert was first acknowledged by the user after it was presented.

## Retracted Time (`retractedTime`)

The time the alert was retracted after it was presented.

---

```json {% title="Example Low Glucose Alert" %}
{
    "id": "02ccebd2affc472d9b296d4f1f800dfd",
    "time": "2018-05-14T08:17:07.560Z",
    "type": "alert",
    "name": "CGM.lowGlucose",
    "priority": "timeSensitive",
    "trigger": "delayed",
    "triggerDelay": 900,
    "sound": "name",
    "soundName": "Gong",
    "issuedTime": "2018-05-14T08:17:07.560Z",
    "acknowledgedTime": "2018-05-14T08:33:03.254Z",
    "retractedTime": "2018-05-14T08:35:12.884Z",
    "uploadId": "0d92d5c1c22117a18f3620b9e24d3c06"
}
```

## Keep Reading

* [Annotations](../annotations.md)
* [Common Fields](../common-fields.md)
