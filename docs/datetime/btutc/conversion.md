<!-- omit in toc -->
# Conversion Offset (`conversionOffset`)

<!-- omit in toc -->
## Table of Contents

1. [Overview](#overview)
2. [Keep Reading](#keep-reading)

---

## Overview

The conversion offset covers changes resulting from incorrect set up of a device. This includes:

* Device set to the wrong am or pm
* Device set to the wrong day
* Device set to the wrong month
* Device set to the wrong year

The latter two of these changes — device set to the wrong month or year — are reflected in the stored conversion offset on each datum. In a perfect world, BtUTC would also adjust the conversion offset for the former two — device set to the wrong day, am or pm. Unfortunately, it is impossible to distinguish +/- 12 hours difference between a settings change made because of the device being set to the wrong time, or made due to travel across timezones.

The consequence of this is that the timezone offset stored on a user’s data will not always line up correctly with the timezone the user was in when the data was generated. We are not trying to infer the timezone of data generation, so this is an acceptable consequence. The only timezone information we store is the timezone selected by the user at the time of upload, reflecting the timezone of the most recent data on the device.

---

## Keep Reading

* [Bootstrapping to UTC](../btutc.md)
* [BtUTC Usage](./usage.md)
* [Clock Drift Offset](./clock-drift.md)
* [Timezone Offset](./timezone.md)
* [Datetime Glossary](../glossary.md)
* [Datetime Guide](../../datetime.md)
* [Incorrect Assumptions About Datetime](../assumptions.md)
