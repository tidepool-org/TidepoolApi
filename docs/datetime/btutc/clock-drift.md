# Clock Drift Offset (`clockDriftOffset`) <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

1. [Overview](#overview)
2. [Adjustments For Clock Drift](#adjustments-for-clock-drift)
3. [Clock Drift Offset Starts At Zero](#clock-drift-offset-starts-at-zero)
4. [Keep Reading](#keep-reading)

---

## Overview

The clock drift offset was introduced to handle:

* Small changes (< 15 minutes) to the device display time, made when the user notices the device clock has “drifted” a few minutes from their phone/computer/other standard clock
* Any change interpreted as a change to the timezone offset, the difference between the offset change — rounded to the nearest thirty minutes — and the raw offset change

---

## Adjustments For Clock Drift

Diabetes devices often suffer from “clock drift,” and some users are in the habit of regularly correcting this drift on their devices. Clock drift adjustments can happen unintentionally due to the way device UIs often work: by allowing the user to set only the hour and minutes in the display time, changes the user makes will never be precisely x number of hours earlier or later, but rather x + some seconds. That difference of seconds will be perceived by the BtUTC code as clock drift adjustment.

In the current version of BtUTC, we round time changes to the nearest thirty minutes to determine the timezone offset. Tidepool considers any change of less than fifteen minutes a clock drift adjustment. These thresholds were initially lower due to fractional timezones, but increased because users reported the threshold was too low.

When a user adjusts the clock drift at the same time as making a change related to DST or travel across timezones, we factor the (rounded) value of the change into the timezone offset and the remainder into the clock drift offset.

---

## Clock Drift Offset Starts At Zero

An assumption built into the current code is that the clock drift offset starts at zero for the most recent data upload on the device. This is a simplifying assumption; in most cases, there is probably a small difference between the user’s device time and computer time. As Tidepool continues building a more robust interface, we may introduce a future version that corrects for this difference immediately.

For the current version of BtUTC, it is essential the user selects the timezone that applies to the most recent data on their device — *even if that is not the user’s current timezone*. For example, let us say a user travels from California to Florida, leaving all their diabetes devices in US/Pacific time but uploading from Florida. In this instance, we want the user to select "Pacific" as the timezone, as we would not want to correct for the 3+ hour difference between device time and computer time.

---

## Keep Reading

* [Bootstrapping to UTC](../btutc.md)
* [BtUTC Usage](./usage.md)
* [Conversion Offset](./conversion.md)
* [Timezone Offset](./timezone.md)
* [Datetime Glossary](../glossary.md)
* [Datetime Guide](../../datetime.md)
* [Incorrect Assumptions About Datetime](../assumptions.md)
