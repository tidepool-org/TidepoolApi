<!-- omit in toc -->
# Summary Statistics

<!-- omit in toc -->
## Table of Contents

1. [Overview](#overview)
2. [Calculation](#calculation)
   1. [Threshold Values](#threshold-values)
   2. [Hourly Bucket Data Fields](#hourly-bucket-data-fields)
      1. [GlucoseBucket](#glucosebucket)
   3. [Summary Period Data Fields](#summary-period-data-fields)
      1. [GlucosePeriod](#glucoseperiod)
      2. [GlucoseRange](#glucoserange)
   4. [Handling Multiple Data Sources](#handling-multiple-data-sources)

---

# Overview

Tidepool Platform automatically calculates several summary statistics for each user as they upload diabetes data into their account. Currently supported data types are CGM and BGM, from [Continuous Glucose Monitors][cgm] and [Blood Glucose Meters][bgm], respectively. Our plan is to add insulin delivery summaries as well in the future.

The following diagram illustrates how the overall process works using manual [Tidepool Uploader][uploader] upload as an example. The same process applies regardless of how the data arrives in the user's account. Other examples are automatically uploading using [Tidepool Mobile][mobile], or via cloud-to-cloud import from [Dexcom Clarity][dexcom_clarity] or [Abbott LibreView][abbott_libreview], or even 3rd party applications such as [xDrip][xdrip].

**NOTE:** The summary calculation itself is nearly instantaneous. However, it is triggered by the arrival of new data so depending on the path of the upload it may take anywhere from few minutes to several hours for the summary statistics to be recalculated.

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

   loop Every 30 seconds
      Platform->>Platform: Re-calculate summary data
      Platform->>Platform: Store summary data
   end
   Platform->>Clinic: Summary available via patient list
```

# Calculation

The summary calculation is done in batches of up to 250 most out-of-date user accounts, up to 4 batches in one iteration, where each iteration may begin every 30 seconds. Thus, each calculation iteration may update up to 1,000 accounts. The calculation for each user proceeds as shown in the diagram below:

```mermaid
sequenceDiagram
   autonumber
   participant Device as Device
   participant Samples as Samples
   participant Buckets as Buckets
   participant Periods as Periods

   Device->>Samples: Upload CGM and/or BGM samples
   Samples->>Buckets: Summarize by type into 1-hour buckets over 60 days
   Buckets->>Periods: Summarize by type into 1, 7, 14, 30 day periods
```

Each user's data is first summarized into a set of 1-hour buckets separated by type (CGM or BGM) over the last 60 days, for a maximum of 1,440 buckets per type. The 60 day window is backwards from the date of the last uploaded data for each user, not the current date. The window may be shorter than 60 days of data if the user has not uploaded enough data. The window may also contain gaps.

The 1-hour buckets are then further summarized by type (CGM, BGM) into 1, 7, 14, and 30 day periods again backwards from the date of last uploaded data. In each period record, there is a delta record from the previous period of the corresponding duration. This enables period-over-period comparisons to support advanced dashboards such as _Stanford Timely Interventions for Diabetes Excellence_ or TIDE ([paper][tide]). The following diagram illustrates the relationship of the periods and the corresponding delta record.

```mermaid
gantt
   dateFormat YYYY-MM-DD
   axisFormat %b %d
   todayMarker off
   tickInterval 1week
   last uploaded data :crit, milestone, 2023-08-31, 0d
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

Thus, a user who has both CGM and BGM data may have up to the following number of summary calculation artifacts:

$$
\begin{align}
\begin{bmatrix}
  CGM \\
  BGM
\end{bmatrix} types
\times 60 \space days
\times 24 \space hours
& = 2,880 \space hourly \space buckets \nonumber \\
\begin{bmatrix}
  CGM \\
  BGM
\end{bmatrix} types
\times \begin{bmatrix}
  1 \\
  7 \\
  14 \\
  30
\end{bmatrix} \space days
& = 8 \space periods \nonumber
\end{align}
$$

All of the summary period data is stored within each user account to enable quick sorting and filtering in each clinic's patient list. If a user is a patient of multiple clinics, all clinics share the same summary data.

## Threshold Values

The summary calculation uses the glycemic targets established by [ADA][ada] [standards of care][ada_care] and [AACE][aace] ([paper][aace_paper], [table][aace_table]) to characterize each CGM or BGM glucose sample. The same target ranges are _currently_ used for all users, and not personalized based on the user's diagnosis type or either the user's or the clinic's preferences. The glycemic target ranges are listed in the table below. In addition to the discrete ranges, we also define two additional composite ranges $AnyLow$ and $AnyHigh$. Note also that the $High$ range is inclusive of the $ExtremeHigh$ range.

<table style="text-align: center">
<colgroup>
<col style="background-color: #E0E0E0"/>
<!-- BG range colors from https://github.com/tidepool-org/blip/blob/develop/app/themes/baseTheme.js -->
<col style="background-color: #E9695E"/>
<col style="background-color: #F19181"/>
<col style="background-color: #8DD0A9"/>
<col style="background-color: #B69CE2"/>
<col style="background-color: #856ACF"/>
<col style="background-color: #5438A3"/>
</colgroup>
<thead>
<tr>
<th rowspan="2" style="font-style: italic">
Unit
</th>
<th colspan="2" style="background-image: linear-gradient(to right, #E9695E, #F19181)">

$AnyLow$
</th>
<th rowspan="2">

$Target$
</th>
<th colspan="3" style="background-image: linear-gradient(to right, #B69CE2, #856ACF, #5438A3)">

$AnyHigh$
</th>
</tr>
<tr>
<th>

$VeryLow$
</th>
<th>

$Low$
</th>
<th>

$High$
</th>
<th>

$VeryHigh$
</th>
<th>

$ExtremeHigh$
</th>
</tr>
</thead>
<tbody>
<tr>
<td>

$\frac{mmol}{L}$
</td>
<td>

$v < 3.0$
</td>
<td>

$3.0 ≤ v < 3.9$
</td>
<td>

$3.9 ≤ v ≤ 10.0$
</td>
<td>

$10.0 < v ≤ 13.9$
</td>
<td>

$v > 13.9$
</td>
<td>

$v ≥ 19.4$
</td>
</tr>
<tr>
<td>

$\frac{mg}{dL}$
</td>
<td>

$v < 54$
</td>
<td>

$54 ≤ v < 70$
</td>
<td>

$70 ≤ v ≤ 180$
</td>
<td>

$180 < v ≤ 250$
</td>
<td>

$v > 250$
</td>
<td>

$v ≥ 350$
</td>
</tr>
</tbody>
</table>

<!-- unfortunately stock GFM doesn't support 2-row colum headers >
|       Unit       | $VeryLow$ |      $Low$      |     $Target$     |      $High$       | $VeryHigh$ | $ExtremeHigh$ |
| :--------------: | :-------: | :-------------: | :--------------: | :---------------: | :--------: | :-----------: |
| $\frac{mmol}{L}$ | $v < 3.0$ | $3.0 ≤ v < 3.9$ | $3.9 ≤ v ≤ 10.0$ | $10.0 < v ≤ 13.9$ | $v > 13.9$ |  $v ≥ 19.4$   |
| $\frac{mg}{dL}$  | $v < 54$  |  $54 ≤ v < 70$  |  $70 ≤ v ≤ 180$  |  $180 < v ≤ 250$  | $v > 250$  |   $v ≥ 350$   |
-->

**NOTE:** Tidepool normalizes glucose samples to $\frac{mmol}{L}$ units. If the original sample was in $\frac{mg}{dL}$ units, it is converted using a conversion factor of $18.01559$ derived from the molecular weight of glucose ($C_{6} H_{12} O_{6}$):

$$
12.01070 \frac{g}{mol} \times 6 + 1.00794 \frac{g}{mol} \times 12 + 15.99940 \frac{g}{mol} \times 6 = 180.1559 \frac{g}{mol}
$$

## Hourly Bucket Data Fields

Each bucket has a set of common fields, as well as a set of fields repeated for each of the 7 named summary ranges: $InLow$, $InTarget$, $InHigh$, $InVeryHigh$, $InExtremeHigh$, $InAnyLow$, and $InAnyHigh$. For brevity, in the following table the placeholder $\textbf{Xxx}$ corresponds to those names rather than repeating each set of fields.

### GlucoseBucket

|  CGM  |  BGM  | Field                  | Type     | Unit             | Notes                                                                              |
| :---: | :---: | :--------------------- | :------- | :--------------- | :--------------------------------------------------------------------------------- |
|   ✅   |   ✅   | $Type$                 | $string$ |                  | Type of data in this bucket: `cgm` or `bgm`                                        |
|   ✅   |   ✅   | $Date$                 | $date$   |                  | Start time of the bucket                                                           |
|   ✅   |   ✅   | $LastRecordTime$       | $date$   |                  | Time of the last sample in the bucket                                              |
|   ✅   |       | $LastRecordDuration$   | $int$    | $min$            | Duration of the last sample in the bucket                                          |
|   ✅   |   ✅   | $Total.Glucose$        | $float$  | $\frac{mmol}{L}$ | Sum of all samples in the bucket                                                   |
|   ✅   |       | $Total.Minutes$        | $int$    | $min$            | Sum of minutes covered by all samples in the bucket                                |
|   ✅   |   ✅   | $Total.Records$        | $int$    |                  | Count of all samples in the bucket                                                 |
|   ✅   |   ✅   | $\textbf{Xxx}.Glucose$ | $float$  | $\frac{mmol}{L}$ | Sum of all samples within the thresholds of $Xxx$ in the bucket                    |
|   ✅   |       | $\textbf{Xxx}.Minutes$ | $int$    | $min$            | Sum of minutes covered by each sample within the thresholds of $Xxx$ in the bucket |
|   ✅   |   ✅   | $\textbf{Xxx}.Records$ | $int$    |                  | Count of samples within the thresholds of $Xxx$ in the bucket                      |

## Summary Period Data Fields

* $GlucosePeriod.GlucoseManagementIndex$ is only present if $GlucosePeriod.Total.Percent > 70$
  * It is calculated using the [Jaeb formula][jaeb] to produce a GMI value in $\frac{mmol}{mol}$ units, and then using the [NGSP formula][ngsp] to produce a % HbA1c value
  * It is rounded to one decimal point of precision
* $GlucosePeriod.Delta$ is not recursive: it is only present in the top-level $GlucosePeriod$
* $GlucosePeriod.Total$ is always present, but the threshold ranges are present only if:
  * $GlucosePeriod.DaysInPeriod ≤ 1$ and $GlucosePeriod.Total.Percent > 70$ or
  * $GlucosePeriod.DaysInPeriod > 1$ and $GlucosePeriod.Total.Minutes > 1,440$ (=24 hours)
* $GlucoseRange.Variance$ is only present in $GlucosePeriod.Total$

### GlucosePeriod

|  CGM  |  BGM  | Field                        | Type            | Unit             | Notes                                                            |
| :---: | :---: | :--------------------------- | :-------------- | :--------------- | :--------------------------------------------------------------- |
|   ✅   |   ✅   | $Type$                       | $string$        |                  | Type of data in this period: `cgm` or `bgm`                      |
|   ✅   |   ✅   | $DaysInPeriod$               | $int$           |                  | Number of days in this period: 1, 7, 14, or 30                   |
|   ✅   |   ✅   | $DaysWithData$               | $int$           |                  | Number of days where $Total.Records > 0$                         |
|   ✅   |   ✅   | $HoursWithData$              | $int$           |                  | Number of hours where $Total.Records > 0$                        |
|   ✅   |   ✅   | $Total$                      | $GlucoseRange$  |                  | Totals for all samples regardless of thresholds                  |
|   ✅   |   ✅   | $InVeryLow$                  | $GlucoseRange$  |                  |                                                                  |
|   ✅   |   ✅   | $InLow$                      | $GlucoseRange$  |                  |                                                                  |
|   ✅   |   ✅   | $InTarget$                   | $GlucoseRange$  |                  |                                                                  |
|   ✅   |   ✅   | $InHigh$                     | $GlucoseRange$  |                  |                                                                  |
|   ✅   |   ✅   | $InVeryHigh$                 | $GlucoseRange$  |                  |                                                                  |
|   ✅   |   ✅   | $InExtremeHigh$              | $GlucoseRange$  |                  |                                                                  |
|   ✅   |   ✅   | $InAnyLow$                   | $GlucoseRange$  |                  | $InVeryLow + InLow$                                              |
|   ✅   |   ✅   | $InAnyHigh$                  | $GlucoseRange$  |                  | $InHigh + InVeryHigh$ (this includes $InExtremeHigh$)            |
|   ✅   |   ✅   | $AverageDailyRecords$        | $float$         |                  | $\frac{Total.Records}{DaysInPeriod}$                             |
|   ✅   |   ✅   | $AverageGlucoseMmol$         | $float$         | $\frac{mmol}{L}$ | $\frac{Total.Glucose}{Total.Records}$                            |
|   ✅   |       | $GlucoseManagementIndicator$ | $float$         | % HbA1c          | $(12.71 + 4.70587 \times AverageGlucose) \times 0.09148 + 2.152$ |
|   ✅   |       | $StandardDeviation$          | $float$         | $\frac{mmol}{L}$ | $\sqrt{\frac{Total.Variance}{Total.Minutes}}$                    |
|   ✅   |       | $CoefficientOfVariation$     | $float$         |                  | $\frac{StandardDeviation}{AverageGlucoseMmol}$                   |
|   ✅   |   ✅   | $Delta$                      | $GlucosePeriod$ |                  | Deltas from the previous period of the same duration             |

### GlucoseRange

|  CGM  |  BGM  | Field      | Type    | Unit                 | Notes                                                        |
| :---: | :---: | :--------- | :------ | :------------------- | :----------------------------------------------------------- |
|   ✅   |   ✅   | $Glucose$  | $float$ | $\frac{mmol}{L}$     | Sum of all samples in the period                             |
|   ✅   |       | $Minutes$  | $int$   | $min$                | Sum of minutes covered by each sample in the period          |
|   ✅   |   ✅   | $Records$  | $int$   |                      | Count of samples in the period                               |
|   ✅   |       | $Percent$  | $float$ | %                    | $\frac{\textbf{Xxx}.Records}{Total.Records}$                 |
|   ✅   |       | $Variance$ | $float$ | $(\frac{mmol}{L})^2$ | Calculated using [weighted incremental algorithm][variance]. |

## Handling Multiple Data Sources

In the event there are multiple CGM devices uploading data to the user's account, the initial 1-hour bucketing skips any excess data samples within a _blackout window_ defined relative to each data sample that is included in the bucket. Put another way, each data sample included in the bucket _masks_ any following excess data points until the blackout window expires.

In the following example there is a series of data samples in the current 1-hour bucket coming from a Dexcom G6 CGM which measures CGM every 5 minutes, and another hypotethical CGM device that provides data samples at 1 minute intervals.

| Time       | Device    | Action                                                                |
| ---------- | --------- | --------------------------------------------------------------------- |
| $xx:00:00$ | Dexcom G6 | **Included in calculation.** Sets blackout window to 5 minutes.       |
| $xx:00:30$ | Brand X   | Ignored within blackout window.                                       |
| $xx:01:30$ | Brand X   | Ignored within blackout window.                                       |
| $xx:02:30$ | Brand X   | Ignored within blackout window.                                       |
| $xx:03:30$ | Brand X   | Ignored within blackout window.                                       |
| $xx:04:30$ | Brand X   | Ignored within blackout window.                                       |
| $xx:05:00$ | Dexcom G6 | **Included in calculation.** Resets the blackout window to 5 minutes. |
| $xx:05:30$ | Brand X   | Ignored within blackout window.                                       |
| $xx:06:30$ | Brand X   | Ignored within blackout window.                                       |
| ...        | ...       | ...                                                                   |

The blackout windows are defined as 15 minutes for Abbott FreeStyle Libre devices, and 5 minutes for all other devices.

[ada]: https://diabetes.org/
[ada_care]: https://diabetesjournals.org/care/issue/46/Supplement_1
[aace]: https://pro.aace.com/
[aace_paper]: https://doi.org/10.1016/j.eprac.2022.08.002
[aace_table]: https://www.endocrinepractice.org/article/S1530-891X(22)00576-6/fulltext#tbl6
[tide]: https://pubmed.ncbi.nlm.nih.gov/39506045/
[jaeb]: https://www.jaeb.org/gmi/
[ngsp]: https://ngsp.org/ifcc.asp
[uploader]: https://www.tidepool.org/download
[mobile]: https://www.tidepool.org/download
[dexcom_clarity]: https://clarity.dexcom.com/
[abbott_libreview]: https://www.libreview.com/
[xdrip]: https://github.com/NightscoutFoundation/xDrip
[cgm]: https://diabetes.org/get-involved/advocacy/continuous-glucose-monitors
[bgm]: https://en.wikipedia.org/wiki/Glucose_meter
[variance]: https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance#Weighted_incremental_algorithm
