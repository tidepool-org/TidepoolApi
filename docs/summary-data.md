<!-- omit in toc -->
# Summary Statistics

<!-- omit in toc -->
## Table of Contents

1. [Overview](#overview)
2. [Calculation](#calculation)

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
    Platform->>Platform: Mark account summary as stale
    Platform->>Uploader: OK
    deactivate Platform
    Uploader->>PWD: OK
    deactivate Uploader

    rect rgb(128, 128, 128)
    note over Platform: Background task (within 5 minutes)
    Platform->>Platform: Re-calculate summary data
    Platform->>Platform: Store summary data
    end
    Platform->>Clinic: Summary available via patient list
```

# Calculation

The summary calculation is currently done in batches of 500 accounts at a time. The user's data is stored separated by type (`cbg` or `smbg`) in 1-hour buckets. In the event there are multiple CGM or BGM devices uploading data to the user's account, the current process selects the first device it finds in a given bucket.

<!-- theme: warning -->

> ## TODO
>
> Double-check these details with Alex.

The summary calculation uses the same standard threshold values for all users to characterize each `cbg` or `smbg` glucose value as very low, low, target, high, or very high value. This means the summary calculations are not personalized based on either the user's or the clinic's preferences. The threshold values are:

| Threshold              |   Value | Unit   |
| ---------------------- | ------: | ------ |
| `VeryLowBloodGlucose`  |  <= 3.0 | mmol/L |
| `LowBloodGlucose`      |  <= 3.9 | mmol/L |
| `HighBloodGlucose`     | >= 10.0 | mmol/L |
| `VeryHighBloodGlucose` | >= 13.9 | mmol/L |

Using these threshold values, the summary data is accummulated into 1-hour buckets over the last 30 days, for a total of 720 buckets. It is important to note that the 30 day window is backwards from the last date when the user uploaded data. The data in each bucket varies on the type of data:

|       `cbg`        |       `smbg`       | Field             | Type      | Unit    |
| :----------------: | :----------------: | ----------------- | --------- | ------- |
| :heavy_check_mark: |                    | `VeryLowMinutes`  | `int`     | minutes |
| :heavy_check_mark: | :heavy_check_mark: | `VeryLowRecords`  | `int`     |         |
| :heavy_check_mark: |                    | `LowMinutes`      | `int`     | minutes |
| :heavy_check_mark: | :heavy_check_mark: | `LowRecords`      | `int`     |         |
| :heavy_check_mark: |                    | `TargetMinutes`   | `int`     | minutes |
| :heavy_check_mark: | :heavy_check_mark: | `TargetRecords`   | `int`     |         |
| :heavy_check_mark: |                    | `HighMinutes`     | `int`     | minutes |
| :heavy_check_mark: | :heavy_check_mark: | `HighRecords`     | `int`     |         |
| :heavy_check_mark: |                    | `VeryHighMinutes` | `int`     | minutes |
| :heavy_check_mark: | :heavy_check_mark: | `VeryHighRecords` | `int`     |         |
| :heavy_check_mark: | :heavy_check_mark: | `TotalGlucose`    | `float64` | mmol/L  |
| :heavy_check_mark: |                    | `TotalMinutes`    | `int`     | minutes |
| :heavy_check_mark: | :heavy_check_mark: | `TotalRecords`    | `int`     |         |

These 1-hour buckets are then further summarized for periods of 1, 7, 14 and 30 days to produce the following values:

|       `cgm`        |       `smbg`       | Field                           | Type      | Unit     |
| :----------------: | :----------------: | ------------------------------- | --------- | -------- |
| :heavy_check_mark: | :heavy_check_mark: | `HasAverageGlucose`             | `bool`    |          |
| :heavy_check_mark: |                    | `HasGlucoseManagementIndicator` | `bool`    |          |
| :heavy_check_mark: |                    | `HasTimeCGMUsePercent`          | `bool`    |          |
| :heavy_check_mark: | :heavy_check_mark: | `HasTimeInLowPercent`           | `bool`    |          |
| :heavy_check_mark: | :heavy_check_mark: | `HasTimeInVeryLowPercent`       | `bool`    |          |
| :heavy_check_mark: | :heavy_check_mark: | `HasTimeInTargetPercent`        | `bool`    |          |
| :heavy_check_mark: | :heavy_check_mark: | `HasTimeInHighPercent`          | `bool`    |          |
| :heavy_check_mark: | :heavy_check_mark: | `HasTimeInVeryHighPercent`      | `bool`    |          |
| :heavy_check_mark: |                    | `TimeCGMUsePercent`             | `float64` | %        |
| :heavy_check_mark: |                    | `TimeCGMUseMinutes`             | `int`     | minutes  |
| :heavy_check_mark: |                    | `TimeCGMUseRecords`             | `int`     |          |
| :heavy_check_mark: | :heavy_check_mark: | `AverageGlucose`                | `float64` | mmol/L   |
|                    | :heavy_check_mark: | `TotalRecords`                  | `int`     |          |
| :heavy_check_mark: |                    | `GlucoseManagementIndicator`    | `float64` | mmol/mol |
| :heavy_check_mark: | :heavy_check_mark: | `TimeInVeryLowPercent`          | `float64` | %        |
| :heavy_check_mark: |                    | `TimeInVeryLowMinutes`          | `int`     | minutes  |
| :heavy_check_mark: | :heavy_check_mark: | `TimeInVeryLowRecords`          | `int`     |          |
| :heavy_check_mark: | :heavy_check_mark: | `TimeInLowPercent`              | `float64` | %        |
| :heavy_check_mark: |                    | `TimeInLowMinutes`              | `int`     | minutes  |
| :heavy_check_mark: | :heavy_check_mark: | `TimeInLowRecords`              | `int`     |          |
| :heavy_check_mark: | :heavy_check_mark: | `TimeInTargetPercent`           | `float64` | %        |
| :heavy_check_mark: |                    | `TimeInTargetMinutes`           | `int`     | minutes  |
| :heavy_check_mark: | :heavy_check_mark: | `TimeInTargetRecords`           | `int`     |          |
| :heavy_check_mark: | :heavy_check_mark: | `TimeInHighPercent`             | `float64` | %        |
| :heavy_check_mark: |                    | `TimeInHighMinutes`             | `int`     | minutes  |
| :heavy_check_mark: | :heavy_check_mark: | `TimeInHighRecords`             | `int`     |          |
| :heavy_check_mark: | :heavy_check_mark: | `TimeInVeryHighPercent`         | `float64` | %        |
| :heavy_check_mark: |                    | `TimeInVeryHighMinutes`         | `int`     | minutes  |
| :heavy_check_mark: | :heavy_check_mark: | `TimeInVeryHighRecords`         | `int`     |          |

Notes on the fields in the period summaries:

- `AverageGlucose` value is simply `TotalGlucose` divided by `TotalRecords`.
- The `TimeInXXX` values are only calculated if `TimeCGMUsePercent` is >70% for periods <= 1 day.
- The `TimeInXXX` values are only calculdate if `TotalMinutes` is >1440 minutes (=24 hours).
- `GlucoseManagementIndicator` value is only calculated if `TimeCGMUsePercent` for the period is >70%.
- `GlucoseManagementIndicator` value is calculated as `(12.71 + 4.70587 * AverageGlucose) * 0.09148 + 2.152`, rounded to one decimal point.

<!-- theme: warning -->

> ## TODO
>
> Double-check the GMI formula, source & unit with Alex. The first terms match Jaeb, the latter part is extra.
