# Pump Settings (`pumpSettings`)

## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Type](#type-type)
3. [Active Schedule](#active-schedule-activeschedule)
4. [Basal Schedules](#basal-schedules-basalschedules)
    1. [Rate](#rate-rate)
    2. [Start](#start-start)
5. [Blood Glucose Target](#blood-glucose-target-bgtarget)
6. [Carb Ratio](#carb-ratio-carbratio)
7. [Insulin Sensitivity](#insulin-sensitivity-insulinsensitivity)
8. [Units](#units-units)
9. [Example (client)](#example-client)
10. [Example (ingestion)](#example-ingestion)
11. [Example (storage)](#example-storage)
12. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../reference/data/models/pumpsettings.v1.yaml'
```

---

## Type (`type`)

This is the Tidepool data type representing insulin pump settings at a given point in time — usually the time of a data upload from the device. Most insulin delivery devices do not, unfortunately, keep a historical record of all insulin pump settings whenever a settings change is made.

When ingesting data from Medtronic insulin pumps through the CareLink cloud service, Tidepool has been able to build the full pump settings history from a combination of: current pump settings records (at time of upload to CareLink); and records of changes to particular settings. For Medtronic devices, the time on a pump settings object represents the time at which the settings *became effective.* For all other devices, the time on each pump settings object represents the time when the settings were *read by the insulin pump*.

The functionality available across various insulin pumps on the market is generally similar, making the task of standardization to a common data model very simple. The major difference between pumps is how many alternative settings the pump stores.

For example, most pumps allow storage of multiple basal schedules but only allow the storage of one schedule for BG target, carb ratio, and insulin sensitivity. Tidepool worked on integrating data from devices of this type first, so our data model assumed a single schedule for each of these settings. So when Tidepool started integrating data from Tandem and automatic insulin delivery systems — pumps that allow the storage of several schedules — we added alternate pluralized fields (e.g. BG targets, carb ratios, and insulin sensitivities) structured as a set of key-value pairs, with the schedule names as the keys and the schedules as the values.

Either the singular or plural version of the field must be present for a pump settings event to be valid. All pump settings objects should have all singular versions of these fields, or all plural versions. There are no devices currently on the market (that Tidepool knows of) that would be best modeled with plural BG targets but singular carb ratio and insulin sensitivity, for example.

---

## Active Schedule (`activeSchedule`)

For Tandem pump settings, the active schedule will allow a client application to identify BG targets, carb ratios and insulin sensitivities, as well as which of the basal schedules is active.

---

## Basal Schedules (`basalSchedules`)

Each basal schedule segment object within each array value contains the following properties:

* [Rate](#rate-rate)
* [Start](#start-start)

### Rate (`rate`)

Different insulin pump manufacturers use different terminology for the set of pre-programmed and timed basal rates — one of which is generally running in the background during normal device operation. Tidepool has adopted the term "schedule" to refer to the rates covering a 24 hour day. There must be at least one rate in a schedule; if the schedule has only one rate, we often call this a "flat-rate" schedule, since the same rate will always be in effect.

The basal schedules object encodes all of a user's programmed basal schedules, where the keys on the object are the basal schedule names (user-customizable or manufacturer-preset) and each value is a basal schedule.

A basal schedule, in the Tidepool data model, is an array of objects, where each object has a start and a rate. (We sometimes refer to each of these objects that compose a schedule as a "segment" of the schedule.) The rate is a typical basal rate value, in units of insulin per hour.

### Start (`start`)

The start is an integer value representing the milliseconds into a 24 hour day when the rate should go into effect. Therefore, the first object in the schedule must always have a start of 0 — representing the start of the day at 12:00 am.

All subsequent starts must be positive (they cannot be a negative number) and non-zero. For example, 21600000 would be the start for a basal rate scheduled to go into effect at 6:00 am each day when the schedule is active. Each start must be < 86400000 — the number of milliseconds in 24 hours — as such a value would be equivalent to 0 (12:00 am).

---

## Blood Glucose Target (`bgTarget`)

Each BG target segment object in the array contains a subset of the following properties:

* Low
* High
* Range
* Start
* Target

<!-- theme: info -->

> Either BG target or BG targets (but not both) must be present for a pump settings object to be valid.

A BG target value is used — in combination with an insulin sensitivity factor in a pump's bolus calculator — to calculate a recommended dose of insulin to bring the person with diabetes to the target.

The BG target array on a pump settings event represents a single schedule of target blood glucose values. A common-use case for scheduling more than one BG target is to schedule one target during the day and another higher target during the night-time hours (to help prevent nocturnal hypoglycemia).

Each segment in a BG target schedule is an object with a [start](#start-start). The remaining keys on each object in a BG target array vary according to the pump manufacturer, but will be a subset of: low, high, target and range.

The representation of BG target varies across insulin delivery device manufacturers as follows:

* Animas represents the BG target as a target blood glucose and a range encoded as a single value. For example, if the BG target is 6.0 and the range is 2.0, any blood glucose value +range or -range from the target (between 4.0 and 8.0) is considered "in range" for bolus recommendation calculations.
* Insulet represents the BG target as a target blood glucose and a high threshold. For example, if the BG target is 6.0 and the high threshold is 15.0, correction will *only* calculate if the PwDs blood sugar is higher than 15.0, and will aim to bring blood sugar to 6.0.
* Medtronic represents the BG target as a range defined by a low and a high value. For example, if the lowest value is 4.0 and the highest value is 8.0, corrections will be calculated if blood glucose is outside of this range.
* Tandem represents the BG target as a single target blood glucose value. For example, if the BG target is 6.0, a correction bolus will be calculated above or below this target.

Tidepool has decided to use a common range for all blood glucose-related fields to reflect the range offered by diabetes devices. Some of these values are somewhat illogical (e.g. programming a value of 0), so it is the burden on uploading clients to ensure that the uploaded values are correct.

---

## Carb Ratio (`carbRatio`)

Each carb ratio segment object in the array contains the following properties:

* Amount
* Start

<!-- theme: info -->

> Either carb ratio or carb ratios (but not both) must be present for a pump settings object to be valid.

An insulin-to-carb ratio value is used in an insulin pump's bolus calculator — in combination with a carbohydrate value input by the user — to calculate a recommended dose of insulin to "cover" the carbohydrates to be consumed by the PwD.

The carb ratio array on a pump settings event represents a single schedule of insulin-to-carb ratio values. A common-use case for scheduling more than one carb ratio is to schedule a more aggressive I:C ratio for breakfast. (Due to the Dawn Phenomenon, many people with diabetes need more insulin to "cover" a given number of grams of carbohydrates ingested at this time of day.)

Each segment in a carb ratio schedule is an object with a start and an amount. The [start](#basal-schedules-basalschedules) is an integer value representing the time into a 24-hour day in milliseconds. The amount is an I:C ratio in grams of carbohydrate per unit of insulin.

---

## Insulin Sensitivity (`insulinSensitivity`)

Each insulin sensitivity segment object in the array contains the following properties:

* Amount
* Start

<!-- theme: info -->

> Either insulin sensitivity or insulin sensitivities (but not both) must be present for a pump settings object to be valid.

An insulin sensitivity factor is used — in combination with a blood glucose target in an insulin pump's bolus calculator — to calculate a recommended dose of insulin to bring the PwD to the target.

The insulin sensitivity array on a pump settings event represents a single schedule of insulin sensitivity factors (ISFs). A common-use case for scheduling more than one ISF is to dose more aggressively to bring down hyperglycemia in the morning hours (when the Dawn Phenomenon reduces insulin sensitivity for many people with diabetes).

Each segment in an insulin sensitivity schedule is an object with a start and an amount. The [start](#start-start) is an integer value representing the time into a 24-hour day in milliseconds. The amount is an integer or floating point value (depending on whether the blood glucose units are mg/dL or mmol/L), representing the expected drop in blood glucose for each single unit of insulin dosed.

On bolus calculation events, the insulin sensitivity records the ISF employed in the calculation.

Most pumps make it possible to change the ISF for the bolus *currently being calculated*, without also changing the pump settings. Therefore, the insulin sensitivity value on a bolus calculation may not always match the expected ratio given the user's insulin pump settings at the time of the calculation.

---

## Units (`units`)

Contains the following properties:

* BG
* Carbs

The units object on a pump settings event represents all relevant units for the included settings.

For carbs, there are currently two allowed values: grams and exchange.

Grams is a self-explanitory value and is generally the preferred unit of measurement used in newer insulin pumps. However, Tidepool also offers support for the now-outdated "exchange" scheme for counting carbohydrates — where one exchange is ~10g or ~15g of carbohydrate. Users can upload carbohydrates in exchanges, however this will be converted to grams upon ingestion to Platform.

The blood glucose value may be mg/dL or mmol/L, but Platform will convert all blood glucose and related values to mmol/L upon ingestion. (See [units](./device-data/units.md) for further explanation of blood glucose units.)

---

## Example (client)

```json
{
    "type": "pumpSettings",
    "activeSchedule": "Normal",
    "basalSchedules": {
        "Normal": [
            {
                "start": 0,
                "rate": 1.775
            },
            {
                "start": 48600000,
                "rate": 0.475
            }
        ],
        "Vacation": [
            {
                "start": 0,
                "rate": 1.575
            }
        ],
        "Weekday": [
            {
                "start": 0,
                "rate": 0.875
            },
            {
                "start": 3600000,
                "rate": 0.775
            },
            {
                "start": 63000000,
                "rate": 0.525
            }
        ]
    },
    "units": {
        "carbs": "grams",
        "bg": "mmol/L"
    },
    "bgTarget": [
        {
            "start": 0,
            "low": 4.440598392836427,
            "high": 8.3261219865683
        }
    ],
    "carbRatio": [
        {
            "amount": 21,
            "start": 0
        },
        {
            "amount": 5,
            "start": 10800000
        },
        {
            "amount": 18,
            "start": 25200000
        },
        {
            "amount": 16,
            "start": 63000000
        },
        {
            "amount": 9,
            "start": 73800000
        }
    ],
    "insulinSensitivity": [
        {
            "amount": 4.662628312478248,
            "start": 0
        },
        {
            "amount": 3.2749413147168647,
            "start": 61200000
        }
    ],
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "b9a8484b-a90a-406a-b876-1cd3c36a01ce",
    "id": "c1414f92dc0a4e06bb3cc6bee6a6a491",
    "time": "2018-05-14T08:17:08.996Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (ingestion)

```json
{
    "type": "pumpSettings",
    "activeSchedule": "Normal",
    "basalSchedules": {
        "Normal": [
            {
                "start": 0,
                "rate": 1.05
            },
            {
                "start": 12600000,
                "rate": 1.25
            },
            {
                "start": 72000000,
                "rate": 1.85
            }
        ],
        "Sick": [
            {
                "start": 0,
                "rate": 0.15
            }
        ]
    },
    "units": {
        "carbs": "grams",
        "bg": "mg/dL"
    },
    "bgTargets": {
        "Normal": [
            {
                "start": 0,
                "target": 90
            },
            {
                "start": 28800000,
                "target": 85
            },
            {
                "start": 72000000,
                "target": 90
            }
        ],
        "Sick": [
            {
                "start": 0,
                "target": 90
            }
        ]
    },
    "carbRatios": {
        "Normal": [
            {
                "amount": 22,
                "start": 0
            }
        ],
        "Sick": [
            {
                "amount": 25,
                "start": 0
            },
            {
                "amount": 21,
                "start": 32400000
            },
            {
                "amount": 12,
                "start": 55800000
            }
        ]
    },
    "insulinSensitivities": {
        "Normal": [
            {
                "amount": 94,
                "start": 0
            }
        ],
        "Sick": [
            {
                "amount": 44,
                "start": 0
            }
        ]
    },
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "time": "2018-05-14T08:17:08.997Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Example (storage)

```json
{
    "type": "pumpSettings",
    "activeSchedule": "Normal",
    "basalSchedules": {
        "Normal": [
            {
                "start": 0,
                "rate": 0.825
            },
            {
                "start": 14400000,
                "rate": 0.625
            },
            {
                "start": 82800000,
                "rate": 0.525
            }
        ],
        "Stress": [
            {
                "start": 0,
                "rate": 1.225
            },
            {
                "start": 37800000,
                "rate": 1.175
            }
        ],
        "Vacation": [
            {
                "start": 0,
                "rate": 1.4
            },
            {
                "start": 36000000,
                "rate": 1.525
            },
            {
                "start": 46800000,
                "rate": 0.3
            },
            {
                "start": 68400000,
                "rate": 0.925
            },
            {
                "start": 73800000,
                "rate": 0.675
            }
        ]
    },
    "units": {
        "carbs": "grams",
        "bg": "mmol/L"
    },
    "bgTarget": [
        {
            "start": 0,
            "target": 6.383360189702364,
            "high": 8.048584587016023
        }
    ],
    "carbRatio": [
        {
            "amount": 7,
            "start": 0
        }
    ],
    "insulinSensitivity": [
        {
            "amount": 0.7215972388359193,
            "start": 0
        },
        {
            "amount": 3.5524787142691414,
            "start": 9000000
        },
        {
            "amount": 0.7771047187463747,
            "start": 28800000
        },
        {
            "amount": 0.6660897589254641,
            "start": 39600000
        },
        {
            "amount": 3.830016113821418,
            "start": 61200000
        }
    ],
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:13.999Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "7d965b73-53f3-44b0-9920-716799fbc6c8",
    "id": "e8b564c185484cd9b28447e6ad97a76d",
    "time": "2018-05-14T08:17:08.999Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Bolus Calculator](./device-data/data-types/pump-settings/calculator.md)
* [Common Fields](./device-data/common-fields.md)
* [Datetime Guide](./datetime.md)
* [Diabetes Data Types](./device-data/data-types.md)
* [Self-Monitored Glucose (SMBG)](./device-data/data-types/pump-settings/smbg.md)
* [Units](./device-data/units.md)
* [Upload Metadata](./device-data/data-types/pump-settings/upload.md)
