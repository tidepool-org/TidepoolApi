# Controller Settings (`controllerSettings`)

## Table of Contents

1. [Quick Summary](#quick-summary)
1. [Overview](#overview)
1. [Type](#type-type)
1. [Device](#device-device)
1. [Notifications](#notifications-notifications)
1. [Example](#example)
1. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../reference/data/models/controllersettings/controllersettings.v1.yaml'
```

---

## Overview

This is the Tidepool data type representing the settings on a controller.

<!-- theme: info -->

> Platform does not currently accept deduplicate data, meaning if a user uploads the same data from both a pump and a receiver, Tidepool Uploader will reject one device's data and the deduplicate data will not appear.

---

## Type (`type`)

This is the Tidepool data type to represent controller settings at a given point in time.

---

## Device (`device`)

The device related settings of the controller, if known. The device settings contain the following fields:

* [Firmware Version](#firmware-version-firmwareversion)
* [Hardware Version](#hardware-version-hardwareversion)
* [Manufacturers](#manufacturers-manufacturers)
* [Model](#model-model)
* [Name](#name-name)
* [Serial Number](#serial-number-serialnumber)
* [Software Version](#software-version-softwareversion)

### Firmware Version (`firmwareVersion`)

The firmware version of the controller, if known.

### Hardware Version (`hardwareVersion`)

The hardware version of the controller, if known.

### Manufacturers (`manufacturers`)

The manufacturer(s) of the controller. An array of strings.

### Model (`model`)

The model of the controller, if known.

### Name (`name`)

The name of the controller, if known.

### Serial Number (`serialNumber`)

The serial number of the controller, if known.

### Software Version (`softwareVersion`)

The software version of the controller, if known.

---

## Notifications (`notifications`)

The notification related settings of the controller, if known. The notification settings contain the following fields:

* [Authorization](#authorization-authorization)
* [Alert](#alert-alert)
* [Critical Alert](#critical-alert-criticalalert)
* [Badge](#badge-badge)
* [Sound](#sound-sound)
* [Announcement](#announcement-announcement)
* [Notification Center](#notification-center-notificationcenter)
* [Lock Screen](#lock-screen-lockscreen)
* [Alert Style](#alert-style-alertstyle)

### Authorization (`authorization`)

Indicates whether notifications are allowed on the controller or not. One of the following:

* `authorized` - The controller is authorized to schedule or receive user notifications.
* `denied` - The controller is explicitly NOT authorized to schedule or receive user notifications.
* `ephemeral` - The controller is authorized to schedule or receive user notifications for a limited amount of time
* `notDetermined` - Not yet determined if the controller is authorized to schedule or receive user notifications.
* `provisional` - The controller is provisionally authorized to post noninterruptive user notifications.

### Alert (`alert`)

Whether a normal alert can be presented as a user notification.

### Critical Alert (`criticalAlert`)

Whether a critical alert can be presented as a user notification.

### Badge (`badge`)

Whether a badge can be added to the controller icon as a user notification.

### Sound (`sound`)

Whether a sound can be played as part of a user notification.

### Announcement (`announcement`)

Whether an spoken announcement can be presented a part of a user notification.

### Notification Center (`notificationCenter`)

Whether the central notification center can present a user notification.

### Lock Screen (`lockScreen`)

Whether a user notification can be preseted on the lock screen of the controller.

### Alert Style (`alertStyle`)

The style of alert when normal alert is presented as a user notification. One of the following:

* `alert` - Alerts are displayed in a modal window that must be dismissed explicitly by the user.
* `banner` - Alerts are displayed as a slide-down banner. Banners appear for a short time and then disappear automatically if the user does nothing.
* `none` - No alert is displayed.

---

## Example

```json
{
    "id": "02ccebd2affc472d9b296d4f1f800dfd",
    "time": "2018-05-14T08:17:07.560Z",
    "type": "controllerSettings",
    "device": {
        "firmwareVersion": "1.2",
        "hardwareVersion": "2.3r45",
        "manufacturers": [
            "Acme"
        ],
        "model": "Super Controller",
        "name": "My Controller",
        "serialNumber": "1234567890",
        "softwareVersion": "3.4.5"
    },
    "notifications": {
        "authorization": "authorized",
        "alert": true,
        "criticalAlert": true,
        "badge": true,
        "sound": true,
        "announcement": true,
        "notificationCenter": true,
        "lockScreen": true,
        "alertStyle": "alert"
    },
    "uploadId": "0d92d5c1c22117a18f3620b9e24d3c06"
}
```

## Keep Reading

* [Annotations](./device-data/annotations.md)
* [Common Fields](./device-data/common-fields.md)
* [Out Of Range Values](./device-data/oor-values.md)
* [Units](./device-data/units.md)
