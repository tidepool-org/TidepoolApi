# Bootstrapping to UTC (BtUTC)

## Table of Contents

1. [Overview](#overview)
2. [Across-The-Board Timezone Default](#acrosstheboard-timezone-default)
3. [Daylight Savings Time](#daylight-savings-time)
4. [Keep Reading](#keep-reading)

---

## Overview

[Bootstrapping to UTC](https://github.com/tidepool-org/uploader/blob/develop/lib/TimezoneOffsetUtil.js) (BtUTC) is Tidepool's method of creating an absolute scale of time to track time-related data ingested through Platform. This is an important tool as it can help us define why, for example, an insulin pump's display time is inaccurate. Is it due to Daylight Savings, travel across a different timezone, user error, clock drift, or something else?

This page contains a breakdown of each offset and additional information on this extensive subject. In essence, however, BtUTC is the process of converting local device time into UTC Zulu time. To ensure accuracy,  Platform cross-references the time from three sources of information:

1. The timezone that applies to the user's most recent data on the device (selected at the time of upload)

2. The timestamp of the most recent datum on the device

3. The set of changes to the date & time settings on the device

The timezone and most recent timestamp together allow us to determine the offset from UTC (in minutes) of the most recent data on the device. We then follow the set of date & time settings changes backwards — from the most recent data to the earliest data on the device — and adjust the offset used to convert device local time into UTC.

This method produces a more accurate conversion to UTC than applying a timezone across-the-board because it properly accounts for travel across timezones and better represents the changes to and from Daylight Savings Time.

In its current version, BtUTC now keeps track of three offsets from UTC:

1. [Timezone Offset](./btutc/timezone.md)
2. [Conversion Offset](./btutc/conversion.md)
3. [Clock Drift Offset](./btutc/clock-drift.md)

---

## Across-The-Board Timezone Default

Some traditional fingerstick blood glucose meters that Tidepool supports, do not provide date & time settings changes. For these devices, when Timezone Offset Utility is initialized with an empty array for changes, it defaults to across-the-board timezone application to convert local device time into UTC time.

This means for any users who travel regularly (and change the display time on their diabetes devices when they do), if they view their data in a timezone-aware display, the data from their different device may not always be aligned properly. This is due to using a combination of diabetes devices, some of which use BtUTC and others which use across-the-board application.

This across-the-board timezone application applies for *all* diabetes devices that have no date & time settings changes. Whether this is due to a lack of date & time settings data on the device (at time of upload), or because the device does not store date & time settings changes. This method should produce accurate UTC timestamps if the correct timezone is selected by the user on upload.

---

## Daylight Savings Time

For Tidepool's purposes, all that is important to understand regarding [Daylight Savings Time](./glossary.md#dst) is the following:

* DST is responsible for the lack of a direct 1:1 mapping between timezones and timezone offsets
* Different countries around the world change to and from DST at different dates and times

---

## Keep Reading

* [BtUTC Usage](./btutc/usage.md)
* [Clock Drift Offset](./btutc/clock-drift.md)
* [Conversion Offset](./btutc/conversion.md)
* [Timezone Offset](./btutc/timezone.md)
* [Datetime Glossary](./glossary.md)
* [Datetime Guide](../datetime.md)
* [Incorrect Assumptions About Datetime](./assumptions.md)
