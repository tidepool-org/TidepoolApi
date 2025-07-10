<!-- omit in toc -->
# Basal Insulin (`basal`)

---

This is the Tidepool data type for background insulin dosing — the “constant drip” of insulin programmable in all insulin pumps. Different insulin pump manufacturers use different terminology for this insulin dosing, so we have standardized calling one set of rates covering a 24-hour period a basal “schedule.”

The data model for basal schedules is part of the Tidepool [pump settings type](./pump-settings.md), however, basal data types represent actual intervals of basal insulin delivery and may or may not match the programmed basal schedule.

<!-- theme: info -->

> To calculate the total insulin delivery resulting from a basal event, convert the duration from milliseconds to hours and multiply the result by the rate.

This page documents the fields shared by various basal delivery types. The four delivery types that fall under the larger basal type are:

* [Scheduled](./basal/scheduled.md)
* [Automated](./basal/automated.md)
* [Temporary](./basal/temp.md)
* [Suspend](./basal/suspend.md)

---

## Keep Reading

* [Annotations](../annotations.md)
* [Automated Basals](./basal/automated.md)
* [Common Fields](../common-fields.md)
* [Pump Settings](./pump-settings.md)
* [Scheduled Basals](./basal/scheduled.md)
* [Suppressed Basals](./basal/suppressed.md)
* [Suspend Basals](./basal/suspend.md)
* [Temporary Basals](./basal/temp.md)
* [Units](../units.md)
