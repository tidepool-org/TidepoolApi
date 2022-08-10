# Continuous Glucose Monitor (CGM) Settings (`cgmSettings`): Dexcom (`dexcom`)<!-- omit in toc -->

## Table of Contents<!-- omit in toc -->

1. [Quick Summary](#quick-summary)
2. [Overview](#overview)
3. [Type (`type`)](#type-type)
4. [Firmware Version (`firmwareVersion`)](#firmware-version-firmwareversion)
5. [Hardware Version (`hardwareVersion`)](#hardware-version-hardwareversion)
6. [High Alerts (`highAlerts`)](#high-alerts-highalerts)
7. [Low Alerts (`lowAlerts`)](#low-alerts-lowalerts)
8. [Manufacturers (`manufacturers`)](#manufacturers-manufacturers)
9. [Model (`model`)](#model-model)
10. [Name (`name`)](#name-name)
11. [Out Of Range Alerts (`outOfRangeAlerts`)](#out-of-range-alerts-outofrangealerts)
12. [Rate Of Change Alerts (`rateOfChangeAlerts`)](#rate-of-change-alerts-rateofchangealerts)
13. [Serial Number (`serialNumber`)](#serial-number-serialnumber)
14. [Software Version (`softwareVersion`)](#software-version-softwareversion)
15. [Transmitter ID (`transmitterId`)](#transmitter-id-transmitterid)
16. [Units (`units`)](#units-units)
17. [Examples](#examples)
18. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../reference/data/models/cgmsettings.v1.yaml'
```

---

## Overview

This is the Tidepool data type representing the settings on a continuous glucose monitor (CGM). A CGM consists of a sensor inserted into subcutaneous tissue, attached to a transmitter clipped into the sensor's cradle, then attached to the surface of the  skin with adhesive tape.

Every five minutes, the transmitter sends a blood glucose reading to a receiving device, which can be: an insulin pump with receiving capabilities; a dedicated hardware receiver; or an iPhone with a companion app capable of receiving sensor transmissions via Bluetooth. Retrospective data collection from CGM systems happens via one of these receiving devices.

A CGM system can also be configured to alert the user about glucose values that fall outside a user-selected range.

<!-- theme: info -->

> Platform does not currently accept deduplicate data, meaning if a user uploads the same data from both a pump and a receiver, Tidepool Uploader will reject one device's data and the deduplicate data will not appear.

Currently, Tidepool only supports CGM settings (not to be confused with [CGM devices](https://www.tidepool.org/users/devices)) from Dexcom. However, we plan to offer support for CGM settings from other manufacturers in the future.

---

## Type (`type`)

This is the Tidepool data type to represent CGM settings at a given point in time — usually the time of a data upload from the device. Most CGM-receiving devices do not, unfortunately, keep a historical record of all CGM settings whenever a settings change is made. The safest assumption is that the time on each CGM settings object represents a time when the settings were read by the device, *not* the first moment when the settings became effective.

---

## Firmware Version (`firmwareVersion`)

The firmware version of the CGM, if known.

---

## Hardware Version (`hardwareVersion`)

The hardware version of the CGM, if known.

---

## High Alerts (`highAlerts`)

The high alerts object encodes the user’s preferences for receiving alerts about high blood glucose events (hyperglycemia).

Contains the following:

* Enabled
* Level: Threshold for high BG alerts
* Snooze: Allows the user to configure how often the alert should repeat if the person with diabetes' blood glucose remains above the threshold value. A common value is two hours

---

## Low Alerts (`lowAlerts`)

The low alerts object encodes the user’s preferences for receiving alerts about low blood glucose events (hypoglycemia).

Contains the following:

* Enabled
* Level: Threshold for low BG alerts
* Snooze: Allows the user to configure how often the alert should repeat if the person with diabetes' blood glucose remains below the threshold value. A common value is 15 minutes

---

## Manufacturers (`manufacturers`)

The manufacturer(s) of the CGM. An array of strings.

---

## Model (`model`)

The model of the CGM, if known.

---

## Name (`name`)

The name of the CGM, if known.

---

## Out Of Range Alerts (`outOfRangeAlerts`)

The out of range alerts object encodes the user's settings for receiving alerts from the receiver if the connection between the transmitter and the receiver has been disrupted. (This is typically due to the transmitter being situated physically out of range of the receiver.)

Contains the following:

* Enabled
* Snooze

<!-- theme: info -->

> This value is not like the snooze on high alerts and low alerts. More specifically, the time value in an out of range alerts object is not a setting for time between alerts but rather the *amount* of time (counted by the receiver), that the receiver's data connection with the transmitter has been broken. We plan to migrate to the term "threshold" in the future for maximum clarity.

---

## Rate Of Change Alerts (`rateOfChangeAlerts`)

The rate of change alerts object encodes the user's preferences for receiving alerts when the person with diabetes' blood glucose is changing rapidly — either rising or falling.

Contains the following:

* Enabled
* Rate: The rate of change triggers the alert

<!-- theme: info -->

> For the fall rate, the rate of change must be specified as a *negative* value. Like all blood glucose-related values in the Tidepool data model, both the fall rate and rise rate may be specified in either mg/dL or mmol/L, but will be translated to mmol/L upon ingestion.

---

## Serial Number (`serialNumber`)

The serial number of the CGM, if known.

---

## Software Version (`softwareVersion`)

The software version of the CGM, if known.

---

## Transmitter ID (`transmitterId`)

The transmitter ID of the CGM, if known.

---

## Units (`units`)

The unit of the CGM, if known. One of `mg/dL` or `mmol/L`.

---

## Examples

```json title="Example (client)" lineNumbers=true
{
    "type": "cgmSettings",
    "firmwareVersion": "1.2",
    "hardwareVersion": "2.3r45",
    "highAlerts": {
        "enabled": true,
        "level": 10.82395858253879,
        "snooze": 4500000
    },
    "lowAlerts": {
        "enabled": true,
        "level": 3.33044879462732,
        "snooze": 1800000
    },
    "manufacturers": [
        "Acme"
    ],
    "model": "Turbo CGM III",
    "name": "My CGM",
    "outOfRangeAlerts": {
        "enabled": false,
        "snooze": 1800000
    },
    "rateOfChangeAlerts": {
        "fallRate": {
            "enabled": true,
            "rate": -0.055507479910455335
        },
        "riseRate": {
            "enabled": false,
            "rate": 0.055507479910455335
        }
    },
    "serialNumber": "1234567890",
    "softwareVersion": "3.4.5",
    "transmitterId": "C8E65",
    "units": "mmol/L",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "guid": "6d15f48c-3734-4ad1-8f39-9b374f1d127f",
    "id": "02ccebd2affc472d9b296d4f1f800dfd",
    "time": "2018-05-14T08:17:07.560Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json title="Example (ingestion)" lineNumbers=true
{
    "type": "cgmSettings",
    "firmwareVersion": "1.2",
    "hardwareVersion": "2.3r45",
    "highAlerts": {
        "enabled": true,
        "level": 185,
        "snooze": 2700000
    },
    "lowAlerts": {
        "enabled": true,
        "level": 85,
        "snooze": 900000
    },
    "manufacturers": [
        "Acme"
    ],
    "model": "Turbo CGM III",
    "name": "My CGM",
    "outOfRangeAlerts": {
        "enabled": false,
        "snooze": 3600000
    },
    "rateOfChangeAlerts": {
        "fallRate": {
            "enabled": true,
            "rate": -2
        },
        "riseRate": {
            "enabled": false,
            "rate": 2
        }
    },
    "serialNumber": "1234567890",
    "softwareVersion": "3.4.5",
    "transmitterId": "BE61A",
    "units": "mg/dL",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "time": "2018-05-14T08:17:07.561Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

```json title="Example (storage)" lineNumbers=true
{
    "type": "cgmSettings",
    "firmwareVersion": "1.2",
    "hardwareVersion": "2.3r45",
    "highAlerts": {
        "enabled": true,
        "level": 10.268883783434237,
        "snooze": 4500000
    },
    "lowAlerts": {
        "enabled": true,
        "level": 3.8855235937318735,
        "snooze": 1800000
    },
    "manufacturers": [
        "Acme"
    ],
    "model": "Turbo CGM III",
    "name": "My CGM",
    "outOfRangeAlerts": {
        "enabled": false,
        "snooze": 3600000
    },
    "rateOfChangeAlerts": {
        "fallRate": {
            "enabled": false,
            "rate": -0.11101495982091067
        },
        "riseRate": {
            "enabled": false,
            "rate": 0.16652243973136602
        }
    },
    "serialNumber": "1234567890",
    "softwareVersion": "3.4.5",
    "transmitterId": "E3250",
    "units": "mmol/L",
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:12.561Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "guid": "393c9563-705a-4832-b935-cbf23d759f77",
    "id": "7cb8be46bb9447de8b4f5f90d1bd5486",
    "time": "2018-05-14T08:17:07.561Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```

---

## Keep Reading

* [Annotations](../annotations.md)
* [Continuous Blood Glucose (CBG)](./cbg.md)
* [Common Fields](../common-fields.md)
* [Out Of Range Values](../oor-values.md)
* [Units](../units.md)
