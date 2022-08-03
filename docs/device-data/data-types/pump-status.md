# Pump Status (`pumpStatus`)

## Table of Contents

1. [Quick Summary](#quick-summary)
1. [Overview](#overview)
1. [Type](#type-type)
1. [Basal Delivery](#basal-delivery-basaldelivery)
1. [Battery](#battery-battery)
1. [Bolus Delivery](#bolus-delivery-bolusdelivery)
1. [Delivery Indeterminant](#delivery-indeterminant-deliveryindeterminant)
1. [Reservoir](#reservoir-reservoir)
1. [Example](#example)
1. [Keep Reading](#keep-reading)

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

### State (`state`) (Basal Delivery)

The state of the basal delivery status. One of `cancelingTemporary`, `initiatingTemporary`, `resuming`, `scheduled`, `suspended`, `suspending`, or `temporary`.

### Time (`time`) (Basal Delivery)

The time of the `scheduled` or `suspended` basal delivery status. Only specify if state is `scheduled` or `suspended`.

### Dose (`dose`) (Basal Delivery)

The dose of the `temporary` basal delivery status. Only specify if state is `temporary`. Includes the following fields:

#### Start Time (`startTime`) (Basal Delivery Dose)

The start time of the temporary basal dose.

#### End Time (`endTime`) (Basal Delivery Dose)

The end time of the temporary basal dose.

#### Rate (`rate`) (Basal Delivery Dose)

The rate of the temporary basal dose.

#### Amount Delivered (`amountDelivered`) (Basal Delivery Dose)

The current amount delivered of the temporary basal dose.

---

## Battery (`battery`)

The battery status of the pump, if known. The battery status contains the following fields:

* Time
* State
* Remaining
* Units

### Time (`time`) (Battery)

The time of the battery status, if known.

### State (`state`) (Battery)

The state of the battery status, if known. One of `charging`, `full`, or `unplugged`.

### Remaining (`remaining`) (Battery)

The remaining amount of battery. For units of `percent`, can be in range of `0.0` (empty) to `1.0` (full).

### Units (`units`) (Battery)

The units for the remaining amount of battery, if known. One of `percent`.

---

## Bolus Delivery (`bolusDelivery`)

The bolus delivery status of the pump, if known. The bolus delivery status contains the following fields:

* State
* Dose

### State (`state`) (Bolus Delivery)

The state of the bolus delivery status. One of `canceling`, `delivering`, `initiating`, or `none`.

### Dose (`dose`) (Bolus Delivery)

The dose of the `delivering` bolus delivery status. Only specify if state is `delivering`. Includes the following fields:

#### Start Time (`startTime`) (Bolus Delivery Dose)

The start time of the delivering bolus dose.

#### Amount (`amount`) (Bolus Delivery Dose)

The intended amount of the delivering bolus dose.

#### Amount Delivered (`amountDelivered`) (Bolus Delivery Dose)

The current amount delivered of the delivering bolus dose.

---

## Reservoir (`reservoir`)

The reservoir status of the pump, if known. The reservoir status contains the following fields:

* Time
* Remaining
* Units

### Time (`time`) (Reservoir)

The time of the reservoir status, if known.

### Remaining (`remaining`) (Reservoir)

The remaining amount of insulin in the reservoir.

### Units (`units`) (Reservoir)

The units for the remaining amount of insulin in the reservoir. One of `Units`.

---

## Example

```json
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
    }
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
    }
    "reservoir": {
      "time": "2018-05-14T08:17:03.689Z",
      "remaining": 156,
      "units": "Units"
    },
    "uploadId": "0d92d5c1c22117a18f3620b9e24d3c06"
}
```

## Keep Reading

* [Annotations](./device-data/annotations.md)
* [Common Fields](./device-data/common-fields.md)
* [Out Of Range Values](./device-data/oor-values.md)
* [Units](./device-data/units.md)
