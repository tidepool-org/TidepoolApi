# Timezone Offset (`timezoneOffset`)

## Table of Contents

1. [Overview](#overview)
2. [Time Field Relationships](#time-field-relationships)
3. [Finding A Timezone Offset](#finding-a-timezone-offset)
4. [Upper Threshold For Timezone Offset Changes](#upper-threshold-for-timezone-changes)
5. [Timezone Offset Abbreviations](#timezone-offset-abbreviations)
6. [Keep Reading](#keep-reading)

---

## Overview

A [timezone offset](../glossary.md#timezone-offset) is a positive or negative integer representing an offset from [UTC](../glossary.md#utc) in minutes. For example, San Francisco is –480 minutes (eight hours) behind UTC, reflecting that you must *subtract* eight hours from UTC to get [the local time]( https://www.timeanddate.com/worldclock/difference.html?p1=3875).

Date & time settings changes in a device’s history will factor into updates to the stored timezone offset, conversion offset, or clock drift offset. 

The original version of BtUTC only stored a timezone offset because it was primarily concerned with solving the two most common-use cases for device time changes on diabetes devices:

* Changes resulting from the shift to or from [DST](../glossary.md#dst)
* Changes resulting from travel across timezones

These changes are interpreted as changes to the stored timezone offset on each datum.

---

## Time Field Relationships

Overall, the relationship between the following fields in the Tidepool data model — device time, time, timezone offset, conversion offset and clock drift offset — can be generalized as follows (assuming all appropriate unit conversions have been made):

`Device time = time + timezone offset + conversion offset`

In the most current (and production) version of BtUTC, clock drift offset is stored for data auditing and provenance only.

---

## Finding A Timezone Offset

If you do not have the timezone offset for a particular datum and want to find it, you need two pieces of information:

1. The local timezone name
2. The local datetime OR the UTC time

Because timezones do not always map directly to timezone offsets, another anchor is needed to decide which offset associated with a named timezone to map to. Either the local datetime or the true UTC time for the datum can serve as this anchor.

The reverse is also true: Timezone offsets do not map directly to timezones. For example, Arizona does not participate in [DST](../glossary.md#utc) and has a timezone offset of –420 minutes to UTC year-round. Whereas neighboring New Mexico shares the same offset when DST is *not* in effect, but has an offset of –360 minutes to UTC when DST *is* in effect.

---

## Upper Threshold For Timezone Offset Changes

In occasional instances, a user sets the time on the diabetes device to the wrong month or year and must later correct it. We do not interpret such massive changes to the date & time settings as an adjustment to the timezone offset. Rather, whenever a date & time settings change is larger than the maximum difference possible by traveling between timezones (1,560 minutes), we apply this change as an adjustment to the [conversion offset](#conversion-offset).

---

## Timezone Offset Abbreviations

There is a set of three-letter and four-letter codes used to abbreviate timezone and timezone offset information. For example, PST (Pacific Standard Time) refers to the US/Pacific timezone, which has an offset of –480 minutes to UTC. PDT (Pacific Daylight Time) refers to the same timezone when [DST](../glossary.md#dst) is in effect.

<!-- theme: info -->

> It is important to keep these abbreviations distinct from timezone names. Do not use an abbreviation where a timezone is requested, and vice versa.

---

## Keep Reading

* [Bootstrapping to UTC](../btutc.md)
* [BtUTC Usage](./usage.md)
* [Clock Drift Offset](./clock-drift.md)
* [Conversion Offset](./conversion.md)
* [Datetime Glossary](../glossary.md)
* [Datetime Guide](../../datetime.md)
* [Incorrect Assumptions about Datetime](../assumptions.md)
