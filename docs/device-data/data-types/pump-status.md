<!-- omit in toc -->
# Pump Status (`pumpStatus`)

<!-- omit in toc -->
## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Overview](#overview)
3. [Type (`type`)](#type-type)
4. [Basal Delivery (`basalDelivery`)](#basal-delivery-basaldelivery)
5. [Battery (`battery`)](#battery-battery)
6. [Bolus Delivery (`bolusDelivery`)](#bolus-delivery-bolusdelivery)
7. [Reservoir (`reservoir`)](#reservoir-reservoir)
8. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../reference/data/models/pumpstatus.v1.yaml'
```

---

## Overview

This is the Tidepool data type representing the status of a pump.

---

## Type (`type`)

This is the Tidepool data type to represent the pump status at a given point in time.

---

## Basal Delivery (`basalDelivery`)

The basal delivery status of the pump, if known. The basal delivery status contains the following fields:

* State
* Time
* Dose

<!-- omit in toc -->
### State (`state`) (Basal Delivery)

The state of the basal delivery status. One of `cancelingTemporary`, `initiatingTemporary`, `resuming`, `scheduled`, `suspended`, `suspending`, or `temporary`.

<!-- omit in toc -->
### Time (`time`) (Basal Delivery)

The time of the `scheduled` or `suspended` basal delivery status. Only specify if state is `scheduled` or `suspended`.

<!-- omit in toc -->
### Dose (`dose`) (Basal Delivery)

The dose of the `temporary` basal delivery status. Only specify if state is `temporary`. Includes the following fields:

<!-- omit in toc -->
#### Start Time (`startTime`) (Basal Delivery Dose)

The start time of the temporary basal dose.

<!-- omit in toc -->
#### End Time (`endTime`) (Basal Delivery Dose)

The end time of the temporary basal dose.

<!-- omit in toc -->
#### Rate (`rate`) (Basal Delivery Dose)

The rate of the temporary basal dose.

<!-- omit in toc -->
#### Amount Delivered (`amountDelivered`) (Basal Delivery Dose)

The current amount delivered of the temporary basal dose.

---

## Battery (`battery`)

The battery status of the pump, if known. The battery status contains the following fields:

* Time
* State
* Remaining
* Units

<!-- omit in toc -->
### Time (`time`) (Battery)

The time of the battery status, if known.

<!-- omit in toc -->
### State (`state`) (Battery)

The state of the battery status, if known. One of `charging`, `full`, or `unplugged`.

<!-- omit in toc -->
### Remaining (`remaining`) (Battery)

The remaining amount of battery. For units of `percent`, can be in range of `0.0` (empty) to `1.0` (full).

<!-- omit in toc -->
### Units (`units`) (Battery)

The units for the remaining amount of battery, if known. One of `percent`.

---

## Bolus Delivery (`bolusDelivery`)

The bolus delivery status of the pump, if known. The bolus delivery status contains the following fields:

* State
* Dose

<!-- omit in toc -->
### State (`state`) (Bolus Delivery)

The state of the bolus delivery status. One of `canceling`, `delivering`, `initiating`, or `none`.

<!-- omit in toc -->
### Dose (`dose`) (Bolus Delivery)

The dose of the `delivering` bolus delivery status. Only specify if state is `delivering`. Includes the following fields:

<!-- omit in toc -->
#### Start Time (`startTime`) (Bolus Delivery Dose)

The start time of the delivering bolus dose.

<!-- omit in toc -->
#### Amount (`amount`) (Bolus Delivery Dose)

The intended amount of the delivering bolus dose.

<!-- omit in toc -->
#### Amount Delivered (`amountDelivered`) (Bolus Delivery Dose)

The current amount delivered of the delivering bolus dose.

---

## Reservoir (`reservoir`)

The reservoir status of the pump, if known. The reservoir status contains the following fields:

* Time
* Remaining
* Units

<!-- omit in toc -->
### Time (`time`) (Reservoir)

The time of the reservoir status, if known.

<!-- omit in toc -->
### Remaining (`remaining`) (Reservoir)

The remaining amount of insulin in the reservoir.

<!-- omit in toc -->
### Units (`units`) (Reservoir)

The units for the remaining amount of insulin in the reservoir. One of `Units`.

---

```json {% title="Example Pump Status" %}
{
    "id": "02ccebd2affc472d9b296d4f1f800dfd",
    "time": "2018-05-14T08:17:07.560Z",
    "type": "pumpStatus",
    "basalDelivery": {
      "state": "temporary",
      "dose": {
        "startTime": "2018-05-14T08:12:02.154Z",
        "endTime": "2018-05-14T08:12:32.154Z",
        "rate": 1.25,
        "amountDelivered": 0.35
      }
    },
    "battery": {
      "time": "2018-05-14T08:17:05.421Z",
      "state": "charging",
      "remaining": 0.75,
      "units": "percent"
    },
    "bolusDelivery": {
      "state": "delivering",
      "dose": {
        "startTime": "2018-05-14T08:17:01.482Z",
        "amount": 4.55,
        "amountDelivered": 1.65
      }
    },
    "reservoir": {
      "time": "2018-05-14T08:17:03.689Z",
      "remaining": 156,
      "units": "Units"
    },
    "uploadId": "0d92d5c1c22117a18f3620b9e24d3c06"
}
```

## Keep Reading

* [Annotations](../annotations.md)
* [Common Fields](../common-fields.md)
* [Out Of Range Values](../oor-values.md)
* [Units](../units.md)
