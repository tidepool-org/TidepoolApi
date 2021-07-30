# Glossary

## Table of Contents

1. [BtUTC](#btutc)
2. [Calendar Date](#calendar-date)
3. [Clock Time](#clock-time)
4. [Datetime](#datetime)
5. [Display Time](#display-time)
6. [DST](#dst)
7. [Hammertime](#hammertime)
8. [ISO 8601](#iso-8601)
9. [PwD](#pwd)
10. [Timezone](#timezone)
11. [Timezone Offset](#timezone-offset)
12. [Unix Time](#unix-time)
13. [UTC](#utc)

---

## BtUTC

[Bootstrapping to UTC](./datetime/btutc.md) (BtUTC) is the algorithm Tidepool uses to translate local device time to [UTC](#utc) datetimes.

---

## Calendar Date

An object involving only date information — year, month, and day — and referring to a date in the 365-day Gregorian calendar; represented best in [ISO 8601](#iso-8601) YYYY–MM–DD format.

The 365-day calendar does not quite line up to [UTC](#utc) because it guarantees exactly 365 days in a typical year and 366 in a leap year, while UTC does not. A calendar date does not include [timezone](#timezone) information.

In Tidepool's code, there are two dates stored in a [PwD's](#pwd) profile: birthday and diagnosis date.

Examples:

* 2016–01–10 (10th January 2016)
* 2019–08–27 (27th August 2019)

---

## Clock Time

An object involving only time information — hours, minutes, seconds, and sometimes milliseconds — and referring to a point within a standard 24-hour day.

Examples:

* 6:05 pm in non-ISO 8601 format
* 18:05:00 in [ISO 8601-format](#iso-8601)
* 64805000 in milliseconds

In Tidepool front-end code, clock time is often computed from a [datetime](#datetime) and then stored in milliseconds as `msPer24`.

---

## Datetime

A datetime is an object involving both [clock time](#clock-time) and [date](#calendar-date) information. (Device time and time are both properties in the Tidepool data model that encode datetimes.)

The terms "time" and "timestamp" can be problematic because they do not transparently represent the inclusion of date information. For precision and clarity, we recommend using the term "datetime" when both clock time and date information are part of the object in question (both in documentation and in code).

We have borrowed this terminology from the datetime package in [Python's standard library](https://docs.python.org/2/library/datetime.html).

Examples:

* 11:48 pm, 25th May 2017 in non-ISO 8601 format
* 2017-05-25T23:48:52+00:00 in [ISO 8601-format](#iso-8601)

---

## Display Time

A display time is a type of relative or local datetime. That is, a datetime without [timezone](#timezone) information and therefore not anchored to [UTC](#utc). For example, if you look at a diabetes device right now, you should be able to see a display time (on the datetime display).

---

## DST

Daylight Savings Time (DST) is the practice of advancing [clock time](#clock-time) by an hour during the summer months, so that evening daylight lasts longer.

Many [timezones](#timezone) throughout the world observe DST, but some do not. Local governments decide when the shift to and away from DST occurs.

Examples:

* Most areas in Europe and North America observe DST
* New Zealand and parts of south-eastern Australia observe DST
* Most areas in Africa, Asia and South America do not observe DST

---

## Hammertime

A [Unix time](#unix-time) in milliseconds instead of seconds.

Examples:

* 0 is the hammertime representing 12:00 am, 1st January 1970
* 1495759428000 is the hammertime representing the time this documentation was written

Currently, there are no examples of hammertimes in the data Tidepool stores. However, new front-end data visualization code parses each [ISO-formatted](#ISO-8601) timestamp into a hammertime during the data preprocessing.

---

## ISO 8601

ISO 8601 is the International Organization for Standardization's (ISO) standard covering the exchange of date and time related data, which you can read about [here](https://en.wikipedia.org/wiki/ISO_8601).

Tidepool uses ISO 8601 [datetime](#datetime) formatting for calendar dates and for local and [UTC](#utc) datetimes. We use the "Zulu" format with milliseconds for the time field. For the relative datetime (stored in the device time field), we use the date and time formatting specifications to second precision.

Examples:

* 2017-05-25T23:48:52+00:00 for datetime
* 2017-05-25T23:48:52.000Z for time
* 2017-05-25T23:48:52 for device time
* 11:48 pm, 25th May 2017 with 0 offset from UTC in non-ISO 8601 format

---

## PwD

Person with diabetes (PwD) is used  to avoid the disease-centric term "diabetic." It is very commonly used throughout the diabetes community.

---

## Timezone

A timezone — sometimes referred to as a named timezone or timezone name — is a string referring to a valid timezone from the IANA Time Zone Database. In many cases, a timezone will not match a [timezone offset](#timezone-offset) year-round because of Daylight Savings.

<!-- theme: info -->

> An abbreviation such as PDT for "Pacific Daylight Time" is not a timezone since it contains both timezone and timezone offset information.

Examples:

* US/Pacific is the timezone where Tidepool's headquarters are located
* Pacific/Easter is the timezone for the Easter Islands
* More timezone examples can be seen by hovering on the map on [Moment Timezone's](https://momentjs.com/timezone/) landing page

The upload type in Tidepool's data model stores a timezone in the timezone property.

---

## Timezone Offset

A timezone offset is a positive or negative integer representing an offset from [UTC](#utc) in minutes. In many cases, a [timezone](#timezone) will not match a timezone offset year-round because of Daylight Savings Time.

Examples:

* The US/Pacific timezone ordinarily has an offset to UTC of -480 minutes
* The US/Pacific timezone has an offset of -420 minutes when [DST](#dst) is in effect

Be very careful, both in thought and in code, to keep these concepts of timezone and timezone offset distinct.

Tidepool's data model includes a calculated (via [BtUTC](#btutc)) timezone offset in timezone offset.

---

## Unix Time

Unix time is a machine-friendly method for representing a [datetime](#datetime), defined as the number of seconds that have elapsed since 12:00 am, 1st January 1970. Unix time is sometimes referred to as "POSIX time" or "epoch time."

Examples:

* 0 is the Unix time representing 12:00 am, 1st January 1970
* 1495760648 is the Unix time representing the time this was written

We don't use Unix times at Tidepool. We use [hammertimes](#hammertime) instead.

---

## UTC

Coordinated Universal Time (UTC) is the primary date & time standard by which planet Earth regulates clocks and time.

UTC does not observe [DST](#dst), and is the successor to Greenwich Mean Time (GMT), which is no longer a functioning global standard. In the [ISO 8601](#iso-8601) standard, Z (for "Zulu" from the radio alphabet) is shorthand for representing the UTC timezone offset — which is always 0, by definition

In Tidepool's data model, all time fields are in UTC.

Examples:

* 2004-12-30T13:29:34+000Z in ISO 8601 format
* 1:29 pm, 30th December 2004 with 0 offset from UTC in non-ISO 8601 format
* 2019-08-02T07:13:11+600 in ISO 8601 format
* 7:13 am, 2nd August 2019 with +600 minutes offset from UTC in non-ISO 8601 format
