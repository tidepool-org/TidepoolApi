# Device Event (`deviceEvent`)

This is the Tidepool data type for a variety of events that can occur on diabetes devices, including both insulin pumps and continuous glucose monitors. As a type, it is essentially a "grab bag" of miscellaneous sub-types, where each sub-type has its own data model that often differs widely from sub-type to sub-type.

Along with Tidepool's release of ["Bootstrapping to UTC"](./datetime/btutc.md) (BtUTC), we introduced the current device event model to reflect that this group of sub-types brings together miscellaneous events that are user-initiated or surfaced to the user.

<!-- theme: info -->

> These sub-types are *not* device metadata that may be user-invisible (or irrelevant to the user), such as device model and serial numbers, etc.

## Device Event Sub-Types

* [Alarm](./device-data/data-types/device-event/alarm.md)
* [Calibration](./device-data/data-types/device-event/calibration.md)
* [Prime](./device-data/data-types/device-event/prime.md)
* [Pump Settings Override](./device-data/data-types/device-event/pump-settings-override.md)
* [Reservoir Change](./device-data/data-types/device-event/reservoir-change.md)
* [Status](./device-data/data-types/device-event/status.md)
* [Time Change](./device-data/data-types/device-event/time-change.md)
