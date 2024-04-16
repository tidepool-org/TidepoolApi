<!-- omit in toc -->
# Summary Statistics

<!-- omit in toc -->
## Table of Contents

1. [Overview](#overview)
2. [Calculation](#calculation)
   1. [Threshold Values](#threshold-values)
   2. [Hourly Bucket Data Fields](#hourly-bucket-data-fields)
   3. [Period Data Fields](#period-data-fields)
      1. [Footnotes](#footnotes)
   4. [Handling Multiple Data Sources](#handling-multiple-data-sources)

---

# Overview

Tidepool Platform automatically calculates several summary statistics for each user as they upload diabetes data into their account. Currently supported data types are CGM and BGM, from [Continuous Glucose Monitors](https://diabetes.org/get-involved/advocacy/continuous-glucose-monitors) and [Blood Glucose Meters](https://en.wikipedia.org/wiki/Glucose_meter), respectively. Our plan is to add insulin delivery summaries as well in the future.

The following diagram illustrates how the overall process works using [Tidepool Uploader](https://www.tidepool.org/download) as an example. The same process applies regardless of how the data appears in the user's account. Other examples are uploading using [Tidepool Mobile](https://www.tidepool.org/download), or automatically via import from [Dexcom Clarity](https://clarity.dexcom.com/), or even 3rd party applications such as [xDrip](https://github.com/NightscoutFoundation/xDrip).

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
   note right of Platform: If CGM or BGM data
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

   Device->>Samples: Upload CGM and/or BGM samples
   Samples->>Buckets: Summarize by type into 1-hour buckets
   Buckets->>Periods: Summarize by type into 1, 7, 14, 30 day current periods
   Buckets->>Periods: Summarize by type into 1, 7, 14, 30 day previous periods
```

Each user's data is first summarized into a set of 1-hour buckets separated by type (CGM or BGM) over the last 60 days, for a maximum of 1,440 buckets. The 60 day window is backwards from the date of the last uploaded data for each user, not the present day. The window may be shorter than 60 days of data until the user uploads enough data to fill it. Finally, the window may contain gaps if the user has not uploaded data that fills each bucket.

The 1-hour buckets are then further summarized by type into two sets of current and previous 1, 7, 14, and 30 day periods. One set is for the _current periods_ based on the date of last upload. The second set is for the _previous periods_, that is relative to the earliest date of each _current_ period: 1 day for the 1 day period, 7 days for the 7 day period, and so on. This enables period-over-period comparisons to support advanced dashboards such as Stanford Timely Interventions for Diabetes Excellence (TIDE). The following diagram illustrates the layout of the periods.

```mermaid
gantt
   title Current and Previous Periods
   dateFormat YYYY-MM-DD
   axisFormat %b %d
   todayMarker off
   tickInterval 1week
   last upload     :crit, milestone, 2023-08-31, 0d
   section Current Periods
      current 1d   :active, 2023-08-30, 1d
      current 7d   :active, 2023-08-24, 7d
      current 14d  :active, 2023-08-17, 14d
      current 30d  :active, 2023-08-01, 30d
   section Previous Periods
      previous 1d  :2023-08-29, 1d
      previous 7d  :2023-08-17, 7d
      previous 14d :2023-08-03, 14d
      previous 30d :2023-07-02, 30d
```

Thus, in the end a user who has both CGM and BGM data will have:

* Up to 2,880 1-hour buckets: `[ CGM, BGM ] x (30 * 24) x 2`
* Up to 16 period records: `[ CGM, BGM ] x [ 1d, 7d, 14d, 30d ] x 2`

All of the data is stored within each user account to enable quick sorting and filtering in each clinic's patient list. If a user is a patient of multiple clinics, all clinics share the same summary data.

## Threshold Values

The summary calculation uses the glycemic targets established by [ADA](https://diabetes.org/) [[standards of care](https://diabetesjournals.org/care/issue/46/Supplement_1)] and [AACE](https://pro.aace.com/) [[paper](https://doi.org/10.1016/j.eprac.2022.08.002), [table](https://www.endocrinepractice.org/article/S1530-891X(22)00576-6/fulltext#tbl6)] to characterize each CGM or BGM glucose value as one of very low, low, in range, high, or very high. The same target ranges are currently used for all users, and not personalized based on the user's diagnosis type or either the user's or the clinic's preferences. The glycemic target ranges are:

<!-- Tidepool stores values in mmol/L with conversion factor of 18.01559 -->
|       Unit |    Very Low |                Low |             In Range |                 High |    Very High |
| ---------: | ----------: | -----------------: | -------------------: | -------------------: | -----------: |
| **mmol/L** | value < 3.0 | 3.0 <= value < 3.9 | 3.9 <= value <= 10.0 | 10.0 < value <= 13.9 | value > 13.9 |
|  **mg/dL** |  value < 54 |   54 <= value < 70 |   70 <= value <= 180 |   180 < value <= 250 |  value > 250 |

## Hourly Bucket Data Fields

The data fields in each hourly bucket varies by the type of source data:

|  CGM     |  BGM     | Field             | Type      | Unit    |
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

## Period Data Fields

The data fields in each period record varies by the type of source data, as shown in the table below. Each numerical data field is also accompanied by a corresponding delta field that shows the change between each current and previous period, or vice versa. For example:

* Each `TotalRecords` field has a corresponding `TotalRecordsDelta` field
  * In each _current_ period record, `current.TotalRecordsDelta = current.TotalRecords - previous.TotalRecords`
  * In each _previous_ period record, `previous.TotalRecordsDelta = previous.TotalRecords - current.TotalRecords`

|  CGM     |  BGM     | Field                                                           | Type      | Unit    | Notes                         |
| :------: | :------: | :-------------------------------------------------------------- | :-------- | :------ | :---------------------------- |
| &#10004; | &#10004; | `HasAverageGlucose`                                             | `bool`    |         |                               |
| &#10004; |          | `HasGlucoseManagementIndicator`                                 | `bool`    |         |                               |
| &#10004; |          | `HasTimeCGMUsePercent`                                          | `bool`    |         |                               |
| &#10004; | &#10004; | `HasTimeInLowPercent`                                           | `bool`    |         |                               |
| &#10004; | &#10004; | `HasTimeInVeryLowPercent`                                       | `bool`    |         |                               |
| &#10004; | &#10004; | `HasTimeInTargetPercent`                                        | `bool`    |         |                               |
| &#10004; | &#10004; | `HasTimeInHighPercent`                                          | `bool`    |         |                               |
| &#10004; | &#10004; | `HasTimeInVeryHighPercent`                                      | `bool`    |         |                               |
| &#10004; |          | `TimeCGMUsePercent`                                             | `float64` | %       |                               |
| &#10004; |          | `TimeCGMUsePercentDelta`                                        | `float64` | %       |                               |
| &#10004; |          | `TimeCGMUseMinutes`, `TimeCGMUseMinutesDelta`                   | `int`     | minutes |                               |
| &#10004; |          | `TimeCGMUseRecords`, `TimeCGMUseRecordsDelta`                   | `int`     |         |                               |
| &#10004; | &#10004; | `AverageGlucose`, `AverageGlucoseDelta`                         | `float64` | mmol/L  | `TotalGlucose / TotalRecords` |
|          | &#10004; | `TotalRecords`, `TotalRecordsDelta`                             | `int`     |         |                               |
| &#10004; |          | `GlucoseManagementIndicator`, `GlucoseManagementIndicatorDelta` | `float64` | %Hb1A1c | footnote 1                    |
| &#10004; | &#10004; | `TimeInVeryLowPercent`, `TimeInVeryLowPercentDelta`             | `float64` | %       | footnote 2                    |
| &#10004; |          | `TimeInVeryLowMinutes`, `TimeInVeryLowMinutesDelta`             | `int`     | minutes | footnote 2                    |
| &#10004; | &#10004; | `TimeInVeryLowRecords`, `TimeInVeryLowRecordsDelta`             | `int`     |         | footnote 2                    |
| &#10004; | &#10004; | `TimeInLowPercent`, `TimeInLowPercentDelta`                     | `float64` | %       | footnote 2                    |
| &#10004; |          | `TimeInLowMinutes`, `TimeInLowMinutesDelta`                     | `int`     | minutes | footnote 2                    |
| &#10004; | &#10004; | `TimeInLowRecords`, `TimeInLowRecordsDelta`                     | `int`     |         | footnote 2                    |
| &#10004; | &#10004; | `TimeInTargetPercent`, `TimeInTargetPercentDelta`               | `float64` | %       | footnote 2                    |
| &#10004; |          | `TimeInTargetMinutes`, `TimeInTargetMinutesDelta`               | `int`     | minutes | footnote 2                    |
| &#10004; | &#10004; | `TimeInTargetRecords`, `TimeInTargetRecordsDelta`               | `int`     |         | footnote 2                    |
| &#10004; | &#10004; | `TimeInHighPercent`, `TimeInHighPercentDelta`                   | `float64` | %       | footnote 2                    |
| &#10004; |          | `TimeInHighMinutes`, `TimeInHighMinutesDelta`                   | `int`     | minutes | footnote 2                    |
| &#10004; | &#10004; | `TimeInHighRecords`, `TimeInHighRecordsDelta`                   | `int`     |         | footnote 2                    |
| &#10004; | &#10004; | `TimeInVeryHighPercent`, `TimeInVeryHighPercentDelta`           | `float64` | %       | footnote 2                    |
| &#10004; |          | `TimeInVeryHighMinutes`, `TimeInVeryHighMinutesDelta`           | `int`     | minutes | footnote 2                    |
| &#10004; | &#10004; | `TimeInVeryHighRecords`, `TimeInVeryHighRecordsDelta`           | `int`     |         | footnote 2                    |

### Footnotes

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
