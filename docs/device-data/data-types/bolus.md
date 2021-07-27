# Bolus Insulin (`bolus`)

## Table of Contents

1. [Overview](#overview)
2. [Duration](#duration-duration)
3. [Expected Duration](#expected-duration-expectedduration)
4. [Expected Extended](#expected-extended-expectedextended)
5. [Expected Normal](#expected-normal-expectednormal)
6. [Extended](#extended-extended)
7. [Normal](#normal-normal)
8. [Keep Reading](#keep-reading)

---

## Overview

This is the Tidepool data type for one-time doses of fast-acting insulin programmed on an insulin pump to "cover" meals or correct high blood glucose (hyperglycemia). A bolus event can be interrupted or canceled, so the Tidepool data model includes fields to represent programmed vs. delivered bolus amounts and durations. This is very important for behavioral auditing and statistical analysis of a PwD's data to know exactly how much insulin was delivered.

Insulin pumps provide several strategies for delivering boluses of insulin. Each manufacturer uses different terminology for each strategy, although the strategies are equivalent across insulin pumps.

This page documents the fields shared by various bolus sub-types. The three sub-types that fall under the larger bolus type are:

* [Combination](./device-data/data-types/bolus/combination.md)
* [Extended](./device-data/data-types/bolus/extended.md)
* [Normal](./device-data/data-types/bolus/normal.md)
---

## Duration (`duration`)

The duration field represents the actual elapsed duration of time, in milliseconds, spent delivering the extended bolus.

The user interface for some insulin pumps allows a user to program an extended bolus with a 0 duration. This is logically equivalent to a normal bolus but for the sake of clarity, Tidepool preserves the record as a sub-type "extended" and allows the upload of the event with a value of 0 for duration.

In the case of combination boluses, the duration is the elapsed time for the extended portion of the bolus. While some insulin pumps (generally ones that deliver normal insulin doses at a slower rate for user comfort) include the duration of the normal delivery in the data, Tidepool does not currently include this information in our data model. It is theoretically possible for a user to input 0 duration for the extended portion of a combo bolus, effectively programming a normal bolus in a total amount equal to the normal and extended insulin values added together.

---

## Expected Duration (`expectedDuration`)

When an extended bolus is interrupted or canceled by the user, the expected duration field is used to store the value of the *original* programmed dose of insulin represented in extended (whereas duration encodes the *actual* elapsed duration of dose delivery).

The value of expected duration must be greater than or equal to the duration, since anything less cannot be interrupted or canceled by a bolus.

<!-- theme: info -->

> The expected duration can only be equal to the duration in the very rare and special case that the duration is 0. See [duration](#duration) for discussion of the values for this field.

---

## Expected Extended (`expectedExtended`)

When an extended bolus is interrupted or canceled by the user, the expected extended field is used to store the value of the *original* programmed dose of insulin (whereas extended represents the value of the *actual* delivered dose).

<!-- theme: warning -->

> If a combination bolus is interrupted or canceled during the extended portion of delivery, the normal delivery should have completed successfully, so the expected normal field should *not* have a value. An example of this type of interruption appears in the examples below.

---

## Expected Normal (`expectedNormal`)

When a bolus is interrupted or canceled by the user, the expected normal field is used to store the value of the *original* programmed dose of insulin (whereas normal represents the value of the *actual* delivered dose).

The minimum value of expected normal is any value greater than normal since anything less or equal to normal cannot be interrupted or canceled by a bolus.

---

## Extended (`extended`)

The extended field represents the numerical value of the insulin dose delivered over the duration by an insulin pump. To avoid noise in the data, Platform does not allow the upload of boluses with a total delivered dose of 0 units.

<!-- theme: warning -->

> If a combination bolus is interrupted or canceled during the normal portion of delivery, the extended delivery should *not* have begun. The value of extended and duration should be 0; Expected extended and expected duration *should* have values.

---

## Normal (`normal`)

The normal field represents the numerical value of the dose of insulin delivered by an insulin pump. To avoid noise in the data, Platform does not allow the upload of boluses with a total delivered dose of 0 units.

The *only* exception allowing a bolus with a normal of 0 units to upload through Platform, is if a user programs a bolus but cancels the delivery before any insulin has been successfully delivered. This should result in an expected normal field with a value greater than 0.

Insulin pumps generally include a maximum bolus setting that a user can customize to their typical dosing to prevent accidental delivery of very large doses of insulin. Tidepool could not find a default maximum dose in insulin pumps and has chosen 100 units as an arbitrarily large maximum.

<!-- theme: info -->

> A 0 for normal is allowable in more circumstances for a combination bolus than for a simple normal bolus. As long as the extended is non-zero for the combination bolus, normal may have a value of 0 without the requirement that a non-zero expected normal also be present.

---

## Keep Reading

* [Annotations](./device-data/annotations.md)
* [Combination Bolus](./device-data/data-types/bolus/combination.md)
* [Common Fields](./device-data/common-fields.md)
* [Extended Bolus](./device-data/data-types/bolus/extended.md)
* [Normal Bolus](./device-data/data-types/bolus/normal.md)
* [Pump Settings](./device-data/data-types/pump-settings.md)
* [Units](./device-data/units.md)
