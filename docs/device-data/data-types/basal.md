# Basal Insulin (`basal`)

### Table of Contents

1. [Overview](#overview)
2. [Duration](#duration-duration)
3. [Expected duration](#expected-duration-expectedduration)
4. [Rate](#rate-rate)
5. [Schedule name](#schedule-name-schedulename)
6. [Keep reading](#keep-reading)

---

## Overview

This is the Tidepool data type for background insulin dosing — the “constant drip” of insulin programmable in all insulin pumps. Different insulin pump manufacturers use different terminology for this insulin dosing, so we have standardized calling one set of rates covering a 24-hour period a basal “schedule.”

The data model for basal schedules is part of the Tidepool [pump settings type](./device-data/data-types/pump-settings.md), however, basal data types represent actual intervals of basal insulin delivery and may or may not match the programmed basal schedule.

<!-- theme: info -->

> To calculate the total insulin delivery resulting from a basal event, convert the duration from milliseconds to hours and multiply the result by the rate.

This page documents the fields shared by various basal delivery types. The four delivery types that fall under the larger basal type are:

* [Scheduled](./device-data/data-types/basal/scheduled.md)
* [Automated](./device-data/data-types/basal/automated.md)
* [Temporary](./device-data/data-types/basal/temp.md)
* [Suspend](./device-data/data-types/basal/suspend.md)

---

## Duration (`duration`)

In Platform, the duration field is required on all basals. We define duration as the period of time that a basal runs or, in the case of suspend basals, the period of time a suspension of insulin occurs.

Depending on how some pumps' insulin pulses are scheduled, the actual duration of the basal may
differ slightly from the scheduled duration. This explains why some pumps' duration results in odd numbers of milliseconds (e.g. 3600001 for a basal event lasting an hour).

Platform expects the duration value of basals to be >= 0 and <= 604800000  milliseconds (seven days).

---

## Expected duration (`expectedDuration`)

Many insulin pumps provide information on the expected duration of basals in addition to the *actual* duration of basals. (These values may differ in the case of a basal being suspended or canceled.) Where this is true, Platform will provide the same information. If you do not know what the expected duration is, do not include this information as it is an optional field.

---

## Rate (`rate`)

Different insulin pump manufacturers offer the ability to program basal rates with different levels of precision in terms of significant digits on the rate.

Tidepool endeavors to represent each rate accurately, so occasionally when values are stored to a falsely large number, Platform will round the raw rate value to match the significant digits of precision advertised by the manufacturer.

Many insulin pump manufacturers do not allow a basal rate higher than 10.0 or 15.0 units per hour; Platform will reject any value higher than 100.0 units per hour.

---

## Schedule name (`scheduleName`)

Tidepool would love to surface the basal schedule names for every pump manufacturer. Unfortunately, most manufacturers do not provide this information or record pump setting changes. In some cases, we can find this information ourselves by looking up the active pump settings at the time of a particular basal event.

Schedule name is an optional field and should only be added to basal data when directly available from an insulin pump's raw data, or if it can be inferred with high confidence via lookup against a complete pump settings history.

---

### Keep reading:

* [Annotations](./device-data/annotations.md)
* [Automated basals](./device-data/data-types/basal/automated.md)
* [Common fields](./device-data/common-fields.md)
* [Pump settings](./device-data/data-types/pump-settings.md)
* [Scheduled basals](./device-data/data-types/basal/scheduled.md)
* [Suppressed basals](./device-data/data-types/basal/suppressed.md)
* [Suspend basals](./device-data/data-types/basal/suspend.md)
* [Temporary basals](./device/data/data-types/basal/temp.md)
* [Units](./device-data/units.md)