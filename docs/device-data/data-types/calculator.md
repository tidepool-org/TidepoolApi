<!-- omit in toc -->
# Bolus Calculator Records (`wizard`)

<!-- omit in toc -->
## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Type (`type`)](#type-type)
3. [Blood Glucose Input (`bgInput`)](#blood-glucose-input-bginput)
4. [Bolus (`bolus`)](#bolus-bolus)
5. [Carb Input (`carbInput`)](#carb-input-carbinput)
6. [Insulin-To-Carb Ratio (`insulinCarbRatio`)](#insulin-to-carb-ratio-insulincarbratio)
7. [Insulin On Board (`insulinOnBoard`)](#insulin-on-board-insulinonboard)
8. [Recommended (`recommended`)](#recommended-recommended)
9. [Examples](#examples)
10. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../reference/data/models/bolus/calculator.v1.yaml'
```

---

## Type (`type`)

<!-- theme: info -->

> For historical reasons, this type is currently called "wizard." However, Tidepool plans to migrate to the term "bolus calculator" in a future version as wizard is a Medtronic term.

The Tidepool bolus calculator event models user interactions with a bolus calculator. The bolus calculator event is intended to contain the values that were input into the `wizard`, as well as any recommendations that the calculator may have made. (This event does not automatically record whether the recommendations made were followed.)

Some insulin pumps record every user interaction with the bolus calculator, regardless of whether a bolus resulted from the interaction or not. However, only user interactions with the bolus calculator *that result in a bolus event* should be uploaded to Platform, to avoid noise in the data. The resulting bolus should also be included on the bolus calculator event — see [linking events](../linking-events.md) for details.

---

## Blood Glucose Input (`bgInput`)

Like all blood glucose-related fields, the BG input should be uploaded in either mg/dL or mmol/L, as appropriate to how the data is retrieved from the device. However, all values will be converted to mmol/L on ingestion.

---

## Bolus (`bolus`)

Only bolus calculator events that result in a bolus should be uploaded to Platform. When uploading through Platform, the bolus should only be submitted embedded within the appropriate bolus calculator event.

See [linking events](../linking-events.md) for more details on how events of different types are linked in Platform.

---

## Carb Input (`carbInput`)

Not every use of a pump's bolus calculator involves the input of carbohydrates; a user may be using the calculator to program a correction bolus. Therefore, the carb input field is optional and should only be used when relevant.

Some devices have a separate field to enter a carbohydrate value on their bolus calculators. On such devices, Tidepool omits the carb input field altogether if a value was not entered. On other devices where the carbohydrate option is always part of the calculator, Tidepool reflects this as a carb input of 0.

<!-- theme: info -->

> Carb input does not necessarily map directly to carbohydrates consumed. A person with diabetes may consume carbohydrates that are *not* recorded through the bolus calculator: either if the user chooses to program a manual or quick bolus to "cover" carbohydrates ingested; or if the PwD consumes carbohydrates unnecessary to bolus for (e.g. carbohydrates consumed to treat hypoglycemia).

---

## Insulin-To-Carb Ratio (`insulinCarbRatio`)

The insulin-to-carb (I:C) ratio is part of an insulin pump's settings. A user may program one I:C ratio to be used across-the-board, or particular ratios on a schedule per each 24-hour day. For more information on these persistent I:C ratios, see [carb ratios](./pump-settings.md#carb-ratio-carbratio).

Most pumps make it possible to change the I:C for the bolus *currently being calculated*, without also changing the pump settings. Therefore, the insulin-to-carb ratio value on a bolus calculation may not always match the expected ratio given the user's insulin pump settings at the time of the calculation.

---

## Insulin On Board (`insulinOnBoard`)

The insulin on board (IOB) field  encodes the pump's estimate of how much insulin is metabolically active in the person with diabetes' system from previous boluses. Some pumps use a simple linear function for estimating the metabolic uptake and consumption of insulin, while others use more complex functions. A key benefit of using an insulin pump is the ability to track IOB in order to avoid "stacking" boluses (taking more insulin on top of a dose that is still active, possibly resulting in hypoglycemia). It is important to include insulin on board in the data to audit bolusing behavior.

On many pumps, insulin on board is also taken into account for the calculation of the [net bolus recommendation](#recommended-net-recommendednet).

---

## Recommended (`recommended`)

The embedded object recommended encodes an insulin delivery device's recommendations for insulin dosing across three fields:

* [Recommended: carb (`recommended.carb`)](#recommended-carb-recommendedcarb)
* [Recommended: correction (`recommended.correction`)](#recommended-correction-recommendedcorrection)
* [Recommended: net (`recommended.net`)](#recommended-net-recommendednet)

<!-- omit in toc -->
### Recommended: carb (`recommended.carb`)

Carb encodes the units of insulin recommended by the device to "cover" the total grams of carbohydrate input by the user into the bolus calculator. The value for carb may be > = 0, as not all boluses involve the ingestion of carbohydrates and may not include a recommended insulin dose to cover carbohydrates about to be ingested.

<!-- omit in toc -->
### Recommended: correction (`recommended.correction`)

Correction encodes the units of insulin recommended by the device to bring the person with diabetes to their target BG given the input blood glucose. On some pumps, or depending on user preference, this value may be negative. A negative recommendation for correction indicates that — given the user's current blood glucose and insulin on board — low blood glucose is predicted and a reduction in insulin dosing (e.g. via a temporary basal rate) may be required in order to bring blood glucose to or within the target.

<!-- omit in toc -->
### Recommended: net (`recommended.net`)

Net is the net number of units of insulin the bolus calculator recommended given the user's inputs. Generally, this net recommendation takes recommended carb, recommended correction, and insulin on board into account, but insulin delivery devices perform this calculation differently. Therefore, Tidepool has chosen to store the calculation's result, rather than make this calculation the responsibility of client applications.

---

## Examples

```json {% title="Example (client)" %}
{
    "type": "wizard",
    "bgInput": 2.109284236597303,
    "bgTarget": {
        "target": 5.82828539059781,
        "range": 1.3876869977613833
    },
    "bolus": "2eda6697f3ed430bb2d8b7c7a124fb13",
    "carbInput": 17,
    "insulinCarbRatio": 19,
    "insulinOnBoard": 21.949,
    "insulinSensitivity": 1.831746837045026,
    "recommended": {
        "carb": 1,
        "correction": -2.75,
        "net": 0
    },
    "units": "mmol/L",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:09",
    "guid": "757cdf1d-516d-47a3-87d3-3d4e8b71504f",
    "id": "09eb73043377472f82b2baf7adfdbc50",
    "time": "2018-05-14T08:17:09.353Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json {% title="Example (ingestion)" %}
{
    "type": "wizard",
    "bgInput": 392,
    "bgTarget": {
        "target": 95,
        "range": 15
    },
    "bolus": {
        "type": "bolus",
        "subType": "normal",
        "normal": 8,
        "expectedNormal": 9.6,
        "clockDriftOffset": 0,
        "conversionOffset": 0,
        "deviceId": "DevId0987654321",
        "deviceTime": "2018-05-14T18:17:09",
        "time": "2018-05-14T08:17:09.353Z",
        "timezoneOffset": 600,
        "uploadId": "SampleUploadId"
    },
    "carbInput": 137,
    "insulinCarbRatio": 13,
    "insulinOnBoard": 24.254,
    "insulinSensitivity": 52,
    "recommended": {
        "carb": 10.5,
        "correction": 5.5,
        "net": 0
    },
    "units": "mg/dL",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:09",
    "time": "2018-05-14T08:17:09.353Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json {% title="Example (storage)" %}
{
    "type": "wizard",
    "bgInput": 16.152676653942503,
    "bgTarget": {
        "low": 3.6079861941795968,
        "high": 6.938434988806917
    },
    "bolus": "22239d4d592b48ae920b28971cceb48b",
    "carbInput": 57,
    "insulinCarbRatio": 24,
    "insulinOnBoard": 24.265,
    "insulinSensitivity": 4.329583433015516,
    "recommended": {
        "carb": 2.5,
        "correction": 2.25,
        "net": 0
    },
    "units": "mmol/L",
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:14.353Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:09",
    "guid": "18d90ea0-5915-4e95-a8b2-cb22819ce696",
    "id": "087c94ccdae84eb5a76b8205a244ec6b",
    "time": "2018-05-14T08:17:09.353Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Common Fields](../common-fields.md)
* [Datetime Guide](../../datetime.md)
* [Diabetes Data Types](../data-types.md)
* [Pump Settings](./pump-settings.md)
* [Self-Monitored Glucose (SMBG)](./smbg.md)
* [Units](../units.md)
* [Upload Metadata](./upload.md)
