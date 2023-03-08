<!-- omit in toc -->
# Usage

<!-- omit in toc -->
## Table of Contents

1. [Overview](#overview)
   1. [Import The Utility](#import-the-utility)
   2. [Initialize The Utility](#initialize-the-utility)
   3. [Employ The Utility'S Fill-In UTC Information](#employ-the-utilitys-fill-in-utc-information)
2. [Tracking The Time Generation Method](#tracking-the-time-generation-method)
3. [Expectations For Time Change Events](#expectations-for-time-change-events)
4. [Keep Reading](#keep-reading)

---

## Overview

Each device driver in the Tidepool Uploader — including for devices without date & time settings changes information — should integrate Timezone Offset Utility as the common way of generating the time, timezone offset, conversion offset, and clock drift offset fields on each datum.

For example, each driver should: import the Utility; initialize the Utility; and employ the Utility's fill-in UTC information.

---

### Import The Utility

```javascript title="JavaScript" lineNumbers=true
var TZOUtil = require('lib/TimezoneOffsetUtil');
```

---

### Initialize The Utility

Initialize the Utility with:

1. User-selected timezone.
2. UTC timestamp of the most recent datum from the device’s history.
3. An array of the date & time settings changes from the device’s history. (If the device does not store date & time settings changes, then an empty array should be passed).

```javascript title="JavaScript" lineNumbers=true
cfg.tzoUtil = new TZOUtil(timezone, mostRecent, changes);
```

---

### Employ The Utility'S Fill-In UTC Information

Employ the Utility’s fill-in UTC info to fill in the:

* Time
* Timezone offset
* Conversion offset
* Clock drift offset

To employ this, you will need the following pieces of time-related information attached to the data:

1. The device time as a string.
(`datum.deviceTime`)

2. An index representing the event’s position in the sequence device events occurred in. This sequence is structured in chronological, monotonically increasing order from earliest to latest datum.
(`datum.index`)

3. A JavaScript Date object (or equivalent) resulting from parsing the device's native datetime format using:
    * `sundial.buildTimestamp` or
    * `sundial.parseFromFormat` (usually this is the object used to produce device time via `sundial.formatDeviceTime`)

```javascript title="JavaScript" lineNumbers=true
_.each(data, function(datum) {
  cfg.tzoUtil.fillInUTCInfo(datum, jsDate);
});
```

---

## Tracking The Time Generation Method

Each instance of the Timezone Offset Utility keeps track of which method for generating the time field is being employed — BtUTC or [across-the-board application](../btutc.md#acrosstheboard-timezone-default) of a timezone. The method of time generation is publicly available through the type property on the instance (i.e. `cfg.tzoUtil.type`) and must be retrieved and provided as the time processing field of [upload metadata](../../device-data/data-types/upload.md).

---

## Expectations For Time Change Events

The partially-built time change events composing the array of changes is provided as the third argument to a new Timezone Offset Utility instance. All timestamps should be [ISO 8601-formatted](../glossary.md#iso-8601), without timezone offset information. The following listed fields should be set through use of Tidepool Uploader's object builder:

* Device time = timestamp
* Change = an object that itself has the following fields:
  * From = timestamp
  * To = timestamp
  * Method = string (optional)
* jsDate = a JavaScript Date constructed from the **to** time
* Index = an index (with an expectation that all indices be monotonically increasing with event order) for the datum that allows it to be sorted on the device in the order that the events actually happened (which will not match device time order in the case of date & time settings changes on the device)

<!-- theme: info -->

> The index does not have to be numerical. For example, in the case of [Dexcom data](../../device-data/data-types/cgm-settings.md), the index is the Dexcom’s internal time, which is monotonically increasing and never affected by adjustments to the Dexcom’s date & time settings.

The array of changes does not need to be sorted before passing it into the Timezone Offset Utility constructor. The changes will be mutated by the Timezone Offset Utility:

* Time will be added (the true UTC timestamp)
* Timezone offset will be added
* Conversion offset will be added
* Clock drift offset will be added
* JavaScript Date will be deleted

(As a historical aside: the choice to mutate the time change events makes for a somewhat deceptive and/or opaque API, but this was felt to be a better choice than repeating the same code [effecting the mutations described above] across all the device drivers. We may change this in the future.)

The fill-in UTC info method from the usage example above also mutates the object passed as its first argument: adding time, timezone offset, conversion offset, and clock drift offset fields. An annotation may additionally be added if no index was provided on the object, which results in uncertainty in the determination of the correct UTC timestamp. (Some diabetes devices do not provide a monotonically increasing index on all events in the device history.)

---

## Keep Reading

* [Bootstrapping to UTC](../btutc.md)
* [Clock Drift Offset](./clock-drift.md)
* [Conversion Offset](./conversion.md)
* [Timezone Offset](./timezone.md)
* [Datetime Glossary](../glossary.md)
* [Datetime Guide](../../datetime.md)
* [Incorrect Assumptions About Datetime](../assumptions.md)
