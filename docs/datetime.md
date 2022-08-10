# Date/Time Guide<!-- omit in toc -->

## Table of Contents<!-- omit in toc -->

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Handling Diabetes Data](#handling-diabetes-data)
   1. [Handling Datetimes On Ingestion](#handling-datetimes-on-ingestion)
   2. [Handling Datetimes In The API Client](#handling-datetimes-in-the-api-client)
4. [Handling Browser-Local Datetimes "Now"](#handling-browser-local-datetimes-now)
5. [Handling User-Significant Dates](#handling-user-significant-dates)
6. [Keep Reading](#keep-reading)

---

## Overview

It can be difficult to handle [datetimes](./datetime/glossary.md#datetime) when dealing with [DST](./datetime/glossary.md#dst), frequent cross-[timezone](./datetime/glossary.md#timezone) travel and technology operating in an always locale-aware manner. There are three main sections in this guide, each relating to a distinct type of datetime regularly encountered in the Tidepool codebase. This list will help you find the appropriate section:

* **[Handling Diabetes Data](#handling-diabetes-data)**: If you are dealing with a time or a device time from a datum conforming to the Tidepool data model
* **[Handling Browser-Local Datetimes "Now"](#handling-browser-local-datetimes-now)**: If you are trying to manipulate the datetime representing a user's action in the present moment — "now"
* **[Handling User-Significant Dates](#handling-user-significant-dates)**: If you are working with any calendar date stored in the user's profile (such as birthday and diagnosis date)

---

## Prerequisites

* Review the [glossary terms](./datetime/glossary.md)
* Read Tidepool's [incorrect assumptions](./datetime/assumptions.md) about diabetes device time
* Read through [this article](https://infiniteundo.com/post/25326999628/falsehoods-programmers-believe-about-time) on falsehoods programmers believe about time

---

## Handling Diabetes Data

No diabetes device stores the datetimes of events that occur in [UTC](./datetime/glossary.md#utc) or UTC-anchored time (with the possible exception of an iPhone serving as a receiver for a Dexcom G5 CGM). To align data from multiple devices on the same timeline reliably, Tidepool has implemented an [algorithm](./datetime/btutc.md) to convert local device time to UTC time.

For the purposes of this document, we will be focusing on what these properties represent and can be used for:

* Time is the inferred [ISO 8601-formatted](./datetime/glossary.md#iso-8601) UTC datetime of the event
* Device time is an ISO 8601-formatted version of the original datetime stored on the diabetes device, only reformatted
* [Timezone offset](./datetime/glossary.md#timezone-offset) is the inferred timezone offset for the event

To calculate time, you must take a relative datetime in device time and subtract the inferred timezone offset to convert the datetime to the absolute UTC scale:

`time = deviceTime - timezoneOffset`

For example, a device time of 12:00 am on January 1st, 2017 for a user uploading with their device in the US/Pacific timezone, would result in an inferred timezone offset of -480 minutes:

`2017-01-01T08:00:00.000Z = 2017-01-01T00:00:00 - -480`

A computer would perform this calculation, having parsed the first two string representations into integer [hammertimes](./datetime/glossary.md#hammertime):

`1483257600000 = 1483228800000 - -28800000`

This equation is true in most cases, but there are more complex edge cases as well (although they are not relevant outside of the [BtUTC algorithm](./datetime/btutc.md).

The user's behavior in managing the devices' display time may also cause complications. Many user interfaces on diabetes devices are not designed well, so errors can occur because they are easier to make in the interface than non-errors. Of course, issues can also arise from user inattention.

In general, it is good to approach diabetes device times with a [set of incorrect assumptions](./datetime/assumptions.md).

---

### Handling Datetimes On Ingestion

Running the BtUTC algorithm gets you most of the way there, but there is still a situation — plus BtUTC edge cases and bugs — that requires the engineer working on data ingestion to manipulate datetimes directly.

Basal schedules and other insulin pump settings are based on a schedule that is expressed in device local time. When a user changes their device's display time settings, the schedule will follow the new display time rather than shifting. Therefore, when the ingestion process needs to look up information from a currently active schedule, the ingestion engineer must translate the event's post-BtUTC time back to a "display time." This will enable the engineer to look up which segment of the currently active schedule the event falls into.

---

### Handling Datetimes In The API Client

In the API client, the guideline for handling diabetes data datetimes is quite simple: Use the time field in the Tidepool data model, in combination with the user's configured timezone preferences.

When using [Moment.js](https://momentjs.com/) to manipulate and/or display datetimes using the time field in the Tidepool data model, in every case your usage should begin with `moment.utc(time).tz(timezone)`. For good examples of this, refer [here](https://github.com/tidepool-org/viz/blob/master/src/utils/datetime.js).

---

## Handling Browser-Local Datetimes "Now"

The reason we cannot use JavaScript's built-in date constructor (jsDate) at Tidepool — particularly when dealing with diabetes device data — is because jsDate only handles two types of [datetime](./datetime/glossary.md#datetime) objects:

* Browser-local datetimes
* UTC datetimes

Since Tidepool generally deals with diabetes device datetimes in a user's configured, *arbitrary* [timezone](./datetime/glossary.md#timezone), jsDate does not provide the required functionality, and [Moment.js](https://momentjs.com/) must be used instead.

When handling browser-local datetimes in the present moment, however, jsDate provides exactly what is needed: a browser-local "now." (This is assuming the user does not manually configure their computer to a different timezone than their geographically current timezone.)

For formatting a browser-local datetime, any tool may be used. Some people who have extensive experience with the strftime datetime-formatting API may prefer d3-time-format or using a combination of libraries.

---

## Handling User-Significant Dates

Currently, the user-significant dates in the Tidepool data model are a person with diabetes' birthday and diagnosis date. These dates are [calendar dates](./datetime/glossary.md#calendar-dates), and as such they do not include any timezone information. Since [UTC](./datetime/glossary.md#utc) is an absolute time scale that is also free from the complications of non-universal timezones, using d3-time-format can provide good examples of this.

---

## Keep Reading

* [Bootstrapping to UTC](./datetime/btutc.md)
* [Datetime Glossary](./datetime/glossary.md)
* [Incorrect Assumptions](./datetime/assumptions.md)
