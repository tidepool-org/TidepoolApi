# Dosing Decision (`dosingDecision`)<!-- omit in toc -->

## Table of Contents<!-- omit in toc -->

1. [Quick Summary](#quick-summary)
2. [Overview](#overview)
3. [Type (`type`)](#type-type)
4. [Reason (`reason`)](#reason-reason)
5. [Original Food (`originalFood`)](#original-food-originalfood)
6. [Food (`food`)](#food-food)
7. [Self Monitored Blood Glucose (`smbg`)](#self-monitored-blood-glucose-smbg)
8. [Carbohydrates On Board (`carbsOnBoard`)](#carbohydrates-on-board-carbsonboard)
9. [Insulin On Board (`insulinOnBoard`)](#insulin-on-board-insulinonboard)
10. [Blood Glucose Target Schedule (`bgTargetSchedule`)](#blood-glucose-target-schedule-bgtargetschedule)
11. [Blood Glucose Historical (`bgHistorical`)](#blood-glucose-historical-bghistorical)
12. [Blood Glucose Forecast (`bgForecast`)](#blood-glucose-forecast-bgforecast)
13. [Recommended Basal (`recommendedBasal`)](#recommended-basal-recommendedbasal)
14. [Recommended Bolus (`recommendedBolus`)](#recommended-bolus-recommendedbolus)
15. [Requested Bolus (`requestedBolus`)](#requested-bolus-requestedbolus)
16. [Warnings (`warnings`)](#warnings-warnings)
17. [Errors (`errors`)](#errors-errors)
18. [Schedule Time Zone Offset (`scheduleTimeZoneOffset`)](#schedule-time-zone-offset-scheduletimezoneoffset)
19. [Units (`units`)](#units-units)
20. [Keep Reading](#keep-reading)
  
---

## Quick Summary

```yaml json_schema
$ref: '../../../reference/data/models/dosingdecision/dosingdecision.v1.yaml'
```

---

## Overview

This is the Tidepool data type representing a dosing decision.

---

## Type (`type`)

This is the Tidepool data type to represent a dosing decision.

---

## Reason (`reason`)

The reason for the dosing decision. The reason is specific to the client performing the dosing decision.

---

## Original Food (`originalFood`)

If the dosing decision is due to an updated carbohydrate entry then this contains the following:

* Time
* Nutrition

### Time (`time`) (Original Food)<!-- omit in toc -->

The time associated with the original, pre-updated food.

### Nutrition (`nutrition`) (Original Food)<!-- omit in toc -->

The nutrition associated with the original, pre-updated food.

---

## Food (`food`)

If the dosing decision is due to a new or updated carbohydrate entry then this contains the following:

* Time
* Nutrition

### Time (`time`) (Food)<!-- omit in toc -->

The time associated with the new or post-updated food.

### Nutrition (`nutrition`) (Food)<!-- omit in toc -->

The nutrition associated with the new or post-updated food.

---

## Self Monitored Blood Glucose (`smbg`)

If the dosing decision is due to a simple bolus requested by the user and the user inputs a self monitored blood glucose then this contains the following:

* Time
* Value

### Time (`time`) (Self Monitored Blood Glucose)<!-- omit in toc -->

The time associated with the self monitored blood glucose.

### Value (`value`) (Self Monitored Blood Glucose)<!-- omit in toc -->

The value of the self monitored blood glucose.

---

## Carbohydrates On Board (`carbsOnBoard`)

The current carbohydrates on board for the dosing decision. Contains the following properties:

* Time
* Amount

### Time (`time`) (Carbohydrates On Board)<!-- omit in toc -->

The time associated with the carbohydrates on board.

### Amount (`amount`) (Carbohydrates On Board)<!-- omit in toc -->

The amount of the carbohydrates on board.

---

## Insulin On Board (`insulinOnBoard`)

The current insulin on board for the dosing decision. Contains the following properties:

* Time
* Amount

### Time (`time`) (Insulin On Board)<!-- omit in toc -->

The time associated with the insulin on board.

### Amount (`amount`) (Insulin On Board)<!-- omit in toc -->

The amount of the insulin on board.

---

## Blood Glucose Target Schedule (`bgTargetSchedule`)

The blood glucose target schedule used in the dosing decision. See [Blood Glucose Target](./pump-settings.md#blood-glucose-target-bgtarget).

---

## Blood Glucose Historical (`bgHistorical`)

An array of historical blood glucose values. The array contain zero to many objects with the following properties:

* Time
* Value

### Time (`time`) (Blood Glucose Historical)<!-- omit in toc -->

The time of this historical blood glucose.

### Value (`value`) (Blood Glucose Historical)<!-- omit in toc -->

The value of this historical blood glucose.

---

## Blood Glucose Forecast (`bgForecast`)

An array of forecast blood glucose values. The array contain zero to many objects with the following properties:

* Time
* Value

### Time (`time`) (Blood Glucose Forecast)<!-- omit in toc -->

The time of this forecast blood glucose.

### Value (`value`) (Blood Glucose Forecast)<!-- omit in toc -->

The value of this forecast blood glucose.

---

## Recommended Basal (`recommendedBasal`)

The basal recommended by the client. Contains the following field:

* Rate
* Duration

### Rate (`rate`) (Recommended Basal)<!-- omit in toc -->

The rate of basal insulin delivery as recommended by the client.

### Duration (`duration`) (Recommended Basal)<!-- omit in toc -->

The duration of basal insulin delivery as recommended by the client.

---

## Recommended Bolus (`recommendedBolus`)

The bolus recommended by the client. Contains the following field:

* Amount

### Amount (`amount`) (Recommended Bolus)<!-- omit in toc -->

The amount of insulin to bolus as recommended by the client.

---

## Requested Bolus (`requestedBolus`)

The actual bolus requested by the user. Contains the following field:

* Amount

### Amount (`amount`) (Requested Bolus)<!-- omit in toc -->

The amount of insulin to bolus as requested by the user.

---

## Warnings (`warnings`)

All warnings that occurred while calculating the dosing decision. The array contains zero to many objects each containing the following properties:

* ID
* Metadata

### ID (`id`) (Warnings)<!-- omit in toc -->

The identifier of the warning. This is specific to the client making the dosing decision.

### Metadata (`metadata`) (Warnings)<!-- omit in toc -->

Any metadata associated with the warning. This is a dictionary with key and value of strings.

---

## Errors (`errors`)

All errors that occurred while calculating the dosing decision. The array contains zero to many objects each containing the following properties:

* ID
* Metadata

### ID (`id`) (Errors)<!-- omit in toc -->

The identifier of the error. This is specific to the client making the dosing decision.

### Metadata (`metadata`) (Errors)<!-- omit in toc -->

Any metadata associated with the error. This is a dictionary with key and value of strings.

---

## Schedule Time Zone Offset (`scheduleTimeZoneOffset`)

The time zone offset in minutes for any schedule specified in the dosing decision (e.g. Blood Glucose Target Schedule).

---

## Units (`units`)

The units of the dosing decision. Contains the following fields:

* Blood Glucose
* Carbohydrate
* Insulin

### Blood Glucose (`bg`) (Units)<!-- omit in toc -->

The blood glucose units of the dosing decision. Can be one of `mg/dL` or `mmol/L`.

### Carbohydrate (`carb`) (Units)<!-- omit in toc -->

The carbohydrate units of the dosing decision. Can be one of `grams` or `exchanges`.

### Insulin (`insulin`) (Units)<!-- omit in toc -->

The insulin units of the dosing decision. Can be one of `Units`.

---

```json title="Example Dosing Decision" lineNumbers=true
{
    "id": "02ccebd2affc472d9b296d4f1f800dfd",
    "time": "2018-05-14T08:17:07.560Z",
    "type": "dosingDecision",
    "uploadId": "0d92d5c1c22117a18f3620b9e24d3c06"
    "originalFood": {
      "time": "2019-08-24T14:15:22Z",
      "nutrition": {
        "absorptionDuration": 10800,
        "carbohydrate": {
          "net": 15
        }
      }
    },
    "food": {
      "time": "2019-08-24T14:15:22Z",
      "nutrition": {
        "absorptionDuration": 10800,
        "carbohydrate": {
          "net": 25
        }
      }
    },
    "smbg": {
      "time": "2019-08-24T14:15:22Z",
      "value": 105
    },
    "carbsOnBoard": {
      "time": "2019-08-24T14:15:22Z",
      "amount": 18
    },
    "insulinOnBoard": {
      "time": "2019-08-24T14:15:22Z",
      "amount": 0.75
    },
    "bgTargetSchedule": [
      {
        "high": 180,
        "low": 80,
        "start": 0
      }
    ],
    "bgHistorical": [
      {
        "time": "2019-08-24T14:15:22Z",
        "value": 105
      }
    ],
    "bgPredicted": [
      {
        "time": "2019-08-24T14:15:22Z",
        "value": 110
      }
    ],
    "recommendedBasal": {
      "rate": 1.25,
      "duration": 180000
    },
    "recommendedBolus": {
      "amount": 2.5
    },
    "requestedBolus": {
      "amount": 2
    },
    "warnings": [
      {
        "id": "unknown",
        "metadata": {
          "extra": "information"
        }
      }
    ],
    "errors": [
      {
        "id": "unknown",
        "metadata": {
          "extra": "information"
        }
      }
    ],
    "scheduleTimeZoneOffset": -480,
    "units": {
      "bg": "mg/dL",
      "carb": "grams",
      "insulin": "Units"
    }
}
```

## Keep Reading

* [Annotations](../annotations.md)
* [Common Fields](../common-fields.md)
* [Out Of Range Values](../oor-values.md)
* [Units](../units.md)
