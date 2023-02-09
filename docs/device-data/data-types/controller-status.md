<!-- omit in toc -->
# Controller Status (`controllerStatus`)

<!-- omit in toc -->
## Table of Contents

1. [Quick Summary](#quick-summary)
2. [Overview](#overview)
3. [Type (`type`)](#type-type)
4. [Battery (`battery`)](#battery-battery)
5. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../reference/data/models/controllerstatus.v1.yaml'
```

---

## Overview

This is the Tidepool data type representing the status of a controller.

---

## Type (`type`)

This is the Tidepool data type to represent the controller status at a given point in time.

---

## Battery (`battery`)

The battery status of the controller, if known. The battery status contains the following fields:

* [Time (`time`)](#time-time)
* [State (`state`)](#state-state)
* [Remaining (`remaining`)](#remaining-remaining)
* [Units (`units`)](#units-units)

<!-- omit in toc -->
### Time (`time`)

The time of the battery status, if known.

<!-- omit in toc -->
### State (`state`)

The state of the battery status, if known. One of `charging`, `full`, or `unplugged`.

<!-- omit in toc -->
### Remaining (`remaining`)

The remaining amount of battery. For units of `percent`, can be in range of `0.0` (empty) to `1.0` (full).

<!-- omit in toc -->
### Units (`units`)

The units for the remaining amount of battery, if known. One of `percent`.

---

```json title="Example" lineNumbers=true
{
    "id": "02ccebd2affc472d9b296d4f1f800dfd",
    "time": "2018-05-14T08:17:07.560Z",
    "type": "controllerStatus",
    "battery": {
      "time": "2018-05-14T08:17:05.421Z",
      "state": "charging",
      "remaining": 0.75,
      "units": "percent"
    },
    "uploadId": "0d92d5c1c22117a18f3620b9e24d3c06"
}
```

## Keep Reading

* [Annotations](../annotations.md)
* [Common Fields](../common-fields.md)
* [Out Of Range Values](../oor-values.md)
* [Units](../units.md)
