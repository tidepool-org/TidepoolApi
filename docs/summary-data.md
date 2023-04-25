<!-- omit in toc -->
# Summary Statistics

<!-- omit in toc -->
## Table of Contents

1. [Overview](#overview)
2. [Calculation](#calculation)
   1. [Threshold Values](#threshold-values)
   2. [Bucket Fields](#bucket-fields)
   3. [Period Fields](#period-fields)
   4. [Handling Multiple Data Sources](#handling-multiple-data-sources)

---

# Overview

Tidepool Platform automatically calculates several summary statistics for each user as they upload diabetes data into their account. Currently supported data types are CGM (`cbg`) and BGM (`smbg`). Our plan is to add insulin pump summaries as well in the future.

The following diagram illustrates how the overall process works using Tidepool Uploader as an example. The same process applies regardless of how the data appears in the user's account. Other examples are uploading using Tidepool Mobile, or automatically via import from Dexcom Clarity, or even 3rd party applications such as xDrip.

```mermaid
sequenceDiagram
   autonumber
   actor PWD as Alice
   participant Uploader as Tidepool Uploader
   participant Platform as Tidepool Platform
   link Platform: https://api.tidepool.org @ https://api.tidepool.org
   actor Clinic as Seastar Endocrinology

   PWD->>Uploader: Connect CGM or BGM device
   activate Uploader
   Uploader->>Platform: Upload diabetes data
   activate Platform
   note right of Platform: If cbg or smbg data
   Platform->>Platform: Mark account summary as out-of-date
   Platform->>Uploader: OK
   deactivate Platform
   Uploader->>PWD: OK
   deactivate Uploader

   loop Every 3 minutes
      Platform->>Platform: Re-calculate summary data
      Platform->>Platform: Store summary data
   end
   Platform->>Clinic: Summary available via patient list
```

# Calculation

The summary calculation is done in batches of 500 most out-of-date user accounts at a time, every 3 minutes. The calculation for each user proceeds as shown in the diagram below:

```mermaid
sequenceDiagram
   autonumber
   participant Device as Device
   participant Samples as Samples
   participant Buckets as Buckets
   participant Periods as Periods

   Device->>Samples: Upload cbg and/or smbg samples
   Samples->>Buckets: Summarize by type into 1-hour buckets
   Buckets->>Periods: Summarize by type into 1, 7, 14, 30 day periods
```

Each user's data is first summarized into a set of 1-hour buckets separated by type (`cbg` or `smbg`) over the last 30 days, for a maximum of 720 buckets. The 30 day window is backwards from the date of the last uploaded data for each user, not the present day. The window may be shorter than 30 days of data until the user uploads enough data to fill it. Finally, the window may contain gaps if the user has not uploaded data that fills each bucket.

The 1-hour buckets are then further summarized by type into a set of 1, 7, 14, and 30 day periods. Thus, in the end a user who has both CGM and BGM data will have:

* Up to 1,440 1-hour buckets: `[ CGM, BGM ] x (30 * 24)`
* Up to 8 period records: `[ CGM, BGM ] x [ 1d, 7d, 14d, 30d ]`

All of the data is stored within each user account to enable quick sorting and filtering in each clinic's patient list. If a user is a patient of multiple clinics, all clinics share the same summary data.

## Threshold Values

The summary calculation uses the glycemic targets established by [ADA](https://diabetes.org/) [[standards of care](https://diabetesjournals.org/care/issue/46/Supplement_1)] and [AACE](https://pro.aace.com/) [[paper](https://doi.org/10.1016/j.eprac.2022.08.002), <!-- markdown-link-check-disable-line -->[table](https://www.endocrinepractice.org/article/S1530-891X(22)00576-6/fulltext#tbl6)] to characterize each `cbg` or `smbg` glucose value as one of very low, low, in range, high, or very high. The same target ranges are currently used for all users, and not personalized based on the user's diagnosis type or either the user's or the clinic's preferences. The glycemic target ranges are:

<!-- Tidepool stores values in mmol/L with conversion factor of 18.01559 -->
|       Unit |    Very Low |                Low |             In Range |                 High |    Very High |
| ---------: | ----------: | -----------------: | -------------------: | -------------------: | -----------: |
| **mmol/L** | value < 3.0 | 3.0 <= value < 3.9 | 3.9 <= value <= 10.0 | 10.0 < value <= 13.9 | value > 13.9 |
|  **mg/dL** |  value < 54 |   54 <= value < 70 |   70 <= value <= 180 |   180 < value <= 250 |  value > 250 |

## Bucket Fields

The data fields in buckets vary by the type of source data:

|  `cbg`   |  `smbg`  | Field             | Type      | Unit    |
| :------: | :------: | :---------------- | :-------- | :------ |
| &#10004; |          | `VeryLowMinutes`  | `int`     | minutes |
| &#10004; | &#10004; | `VeryLowRecords`  | `int`     |         |
| &#10004; |          | `LowMinutes`      | `int`     | minutes |
| &#10004; | &#10004; | `LowRecords`      | `int`     |         |
| &#10004; |          | `TargetMinutes`   | `int`     | minutes |
| &#10004; | &#10004; | `TargetRecords`   | `int`     |         |
| &#10004; |          | `HighMinutes`     | `int`     | minutes |
| &#10004; | &#10004; | `HighRecords`     | `int`     |         |
| &#10004; |          | `VeryHighMinutes` | `int`     | minutes |
| &#10004; | &#10004; | `VeryHighRecords` | `int`     |         |
| &#10004; | &#10004; | `TotalGlucose`    | `float64` | mmol/L  |
| &#10004; |          | `TotalMinutes`    | `int`     | minutes |
| &#10004; | &#10004; | `TotalRecords`    | `int`     |         |

## Period Fields

The data fields in periods vary by the type of source data:

|  `cgm`   |  `smbg`  | Field                           | Type      | Unit    | Notes                         |
| :------: | :------: | :------------------------------ | :-------- | :------ | :---------------------------- |
| &#10004; | &#10004; | `HasAverageGlucose`             | `bool`    |         |                               |
| &#10004; |          | `HasGlucoseManagementIndicator` | `bool`    |         |                               |
| &#10004; |          | `HasTimeCGMUsePercent`          | `bool`    |         |                               |
| &#10004; | &#10004; | `HasTimeInLowPercent`           | `bool`    |         |                               |
| &#10004; | &#10004; | `HasTimeInVeryLowPercent`       | `bool`    |         |                               |
| &#10004; | &#10004; | `HasTimeInTargetPercent`        | `bool`    |         |                               |
| &#10004; | &#10004; | `HasTimeInHighPercent`          | `bool`    |         |                               |
| &#10004; | &#10004; | `HasTimeInVeryHighPercent`      | `bool`    |         |                               |
| &#10004; |          | `TimeCGMUsePercent`             | `float64` | %       |                               |
| &#10004; |          | `TimeCGMUseMinutes`             | `int`     | minutes |                               |
| &#10004; |          | `TimeCGMUseRecords`             | `int`     |         |                               |
| &#10004; | &#10004; | `AverageGlucose`                | `float64` | mmol/L  | `TotalGlucose / TotalRecords` |
|          | &#10004; | `TotalRecords`                  | `int`     |         |                               |
| &#10004; |          | `GlucoseManagementIndicator`    | `float64` | %Hb1A1c | footnote 1                    |
| &#10004; | &#10004; | `TimeInVeryLowPercent`          | `float64` | %       | footnote 2                    |
| &#10004; |          | `TimeInVeryLowMinutes`          | `int`     | minutes | footnote 2                    |
| &#10004; | &#10004; | `TimeInVeryLowRecords`          | `int`     |         | footnote 2                    |
| &#10004; | &#10004; | `TimeInLowPercent`              | `float64` | %       | footnote 2                    |
| &#10004; |          | `TimeInLowMinutes`              | `int`     | minutes | footnote 2                    |
| &#10004; | &#10004; | `TimeInLowRecords`              | `int`     |         | footnote 2                    |
| &#10004; | &#10004; | `TimeInTargetPercent`           | `float64` | %       | footnote 2                    |
| &#10004; |          | `TimeInTargetMinutes`           | `int`     | minutes | footnote 2                    |
| &#10004; | &#10004; | `TimeInTargetRecords`           | `int`     |         | footnote 2                    |
| &#10004; | &#10004; | `TimeInHighPercent`             | `float64` | %       | footnote 2                    |
| &#10004; |          | `TimeInHighMinutes`             | `int`     | minutes | footnote 2                    |
| &#10004; | &#10004; | `TimeInHighRecords`             | `int`     |         | footnote 2                    |
| &#10004; | &#10004; | `TimeInVeryHighPercent`         | `float64` | %       | footnote 2                    |
| &#10004; |          | `TimeInVeryHighMinutes`         | `int`     | minutes | footnote 2                    |
| &#10004; | &#10004; | `TimeInVeryHighRecords`         | `int`     |         | footnote 2                    |

Footnotes

1. `GlucoseManagementIndicator` value is only calculated if `TimeCGMUsePercent` for the period is >70%. It is calculated as follows:
   1. `12.71 + 4.70587 * AverageGlucose` per the [Jaeb formula](https://www.jaeb.org/gmi/) to produce a GMI value in mmol/mol
   2. `GMI * 0.09148 + 2.152` per the [NGSP formula](https://ngsp.org/ifcc.asp) to produce a %HbA1c value
   3. Round the result to one decimal point
2. The `TimeInXXX` values are only calculated if `TimeCGMUsePercent` is >70% for periods <= 1 day, and only if `TotalMinutes` is >1440 minutes (=24 hours) for periods > 1 day.

## Handling Multiple Data Sources

In the event there are multiple CGM devices uploading data to the user's account, the initial 1-hour bucketing skips any excess data samples within a _blackout window_ defined relative to each data sample that is included in the bucket. Put another way, each data sample included in the bucket _masks_ any following excess data points until the blackout window expires.

In the following example there is a series of data samples in the current 1-hour bucket coming from a Dexcom G6 CGM which measures CGM every 5 minutes, and another hypotethical CGM device that provides data samples at 1 minute intervals.

| Time       | Device    | Action                                                                |
| ---------- | --------- | --------------------------------------------------------------------- |
| `xx:00:00` | Dexcom G6 | **Included in calculation.** Sets blackout window to 5 minutes.       |
| `xx:00:30` | Brand X   | Ignored within blackout window.                                       |
| `xx:01:30` | Brand X   | Ignored within blackout window.                                       |
| `xx:02:30` | Brand X   | Ignored within blackout window.                                       |
| `xx:03:30` | Brand X   | Ignored within blackout window.                                       |
| `xx:04:30` | Brand X   | Ignored within blackout window.                                       |
| `xx:05:00` | Dexcom G6 | **Included in calculation.** Resets the blackout window to 5 minutes. |
| `xx:05:30` | Brand X   | Ignored within blackout window.                                       |
| `xx:06:30` | Brand X   | Ignored within blackout window.                                       |
| ...        | ...       | ...                                                                   |

The blackout windows are defined as 15 minutes for Abbott FreeStyle Libre devices, and 5 minutes for all other devices.
