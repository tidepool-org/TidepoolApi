# Pump Status (`pumpStatus`)<!-- omit in toc -->

## Table of Contents<!-- omit in toc -->

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

### State (`state`) (Basal Delivery)<!-- omit in toc -->

The state of the basal delivery status. One of `cancelingTemporary`, `initiatingTemporary`, `resuming`, `scheduled`, `suspended`, `suspending`, or `temporary`.

### Time (`time`) (Basal Delivery)<!-- omit in toc -->

The time of the `scheduled` or `suspended` basal delivery status. Only specify if state is `scheduled` or `suspended`.

### Dose (`dose`) (Basal Delivery)<!-- omit in toc -->

The dose of the `temporary` basal delivery status. Only specify if state is `temporary`. Includes the following fields:

#### Start Time (`startTime`) (Basal Delivery Dose)<!-- omit in toc -->

The start time of the temporary basal dose.

#### End Time (`endTime`) (Basal Delivery Dose)<!-- omit in toc -->

The end time of the temporary basal dose.

#### Rate (`rate`) (Basal Delivery Dose)<!-- omit in toc -->

The rate of the temporary basal dose.

#### Amount Delivered (`amountDelivered`) (Basal Delivery Dose)<!-- omit in toc -->

The current amount delivered of the temporary basal dose.

---

## Battery (`battery`)

The battery status of the pump, if known. The battery status contains the following fields:

* Time
* State
* Remaining
* Units

### Time (`time`) (Battery)<!-- omit in toc -->

The time of the battery status, if known.

### State (`state`) (Battery)<!-- omit in toc -->

The state of the battery status, if known. One of `charging`, `full`, or `unplugged`.

### Remaining (`remaining`) (Battery)<!-- omit in toc -->

The remaining amount of battery. For units of `percent`, can be in range of `0.0` (empty) to `1.0` (full).

### Units (`units`) (Battery)<!-- omit in toc -->

The units for the remaining amount of battery, if known. One of `percent`.

---

## Bolus Delivery (`bolusDelivery`)

The bolus delivery status of the pump, if known. The bolus delivery status contains the following fields:

* State
* Dose

### State (`state`) (Bolus Delivery)<!-- omit in toc -->

The state of the bolus delivery status. One of `canceling`, `delivering`, `initiating`, or `none`.

### Dose (`dose`) (Bolus Delivery)<!-- omit in toc -->

The dose of the `delivering` bolus delivery status. Only specify if state is `delivering`. Includes the following fields:

#### Start Time (`startTime`) (Bolus Delivery Dose)<!-- omit in toc -->

The start time of the delivering bolus dose.

#### Amount (`amount`) (Bolus Delivery Dose)<!-- omit in toc -->

The intended amount of the delivering bolus dose.

#### Amount Delivered (`amountDelivered`) (Bolus Delivery Dose)<!-- omit in toc -->

The current amount delivered of the delivering bolus dose.

---

## Reservoir (`reservoir`)

The reservoir status of the pump, if known. The reservoir status contains the following fields:

* Time
* Remaining
* Units

### Time (`time`) (Reservoir)<!-- omit in toc -->

The time of the reservoir status, if known.

### Remaining (`remaining`) (Reservoir)<!-- omit in toc -->

The remaining amount of insulin in the reservoir.

### Units (`units`) (Reservoir)<!-- omit in toc -->

The units for the remaining amount of insulin in the reservoir. One of `Units`.

---

```json title="Example Pump Status" lineNumbers=true
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
