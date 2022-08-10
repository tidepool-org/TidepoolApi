# Upload Metadata (`upload`)<!-- omit in toc -->

## Table of Contents<!-- omit in toc -->

1. [Quick Summary](#quick-summary)
2. [Type (`type`)](#type-type)
3. [By User (`byUser`)](#by-user-byuser)
4. [Computer Time (`computerTime`)](#computer-time-computertime)
5. [Device Manufacturers (`deviceManufacurers`)](#device-manufacturers-devicemanufacurers)
6. [Device Model (`deviceModel`)](#device-model-devicemodel)
7. [Device Serial Number (`deviceSerialNumber`)](#device-serial-number-deviceserialnumber)
8. [Device Tags (`deviceTags`)](#device-tags-devicetags)
9. [Time Processing (`timeProcessing`)](#time-processing-timeprocessing)
10. [Timezone (`timezone`)](#timezone-timezone)
11. [Upload ID (`uploadId`)](#upload-id-uploadid)
12. [Version (`version`)](#version-version)
13. [Examples](#examples)
14. [Keep Reading](#keep-reading)

---

## Quick Summary

```yaml json_schema
$ref: '../../../../reference/data/models/upload.v1.yaml'
```

---

## Type (`type`)

This is the Tidepool data type most distinct from all others: instead of encoding diabetes device data, the upload type encodes metadata — about uploads of diabetes device data — to Platform.

The fields under this type are:

1. [Quick Summary](#quick-summary)
2. [Type (`type`)](#type-type)
3. [By User (`byUser`)](#by-user-byuser)
4. [Computer Time (`computerTime`)](#computer-time-computertime)
5. [Device Manufacturers (`deviceManufacurers`)](#device-manufacturers-devicemanufacurers)
6. [Device Model (`deviceModel`)](#device-model-devicemodel)
7. [Device Serial Number (`deviceSerialNumber`)](#device-serial-number-deviceserialnumber)
8. [Device Tags (`deviceTags`)](#device-tags-devicetags)
9. [Time Processing (`timeProcessing`)](#time-processing-timeprocessing)
10. [Timezone (`timezone`)](#timezone-timezone)
11. [Upload ID (`uploadId`)](#upload-id-uploadid)
12. [Version (`version`)](#version-version)
13. [Examples](#examples)
14. [Keep Reading](#keep-reading)

---

## By User (`byUser`)

The by user field is provided for data auditing purposes. Since Tidepool provides functionality to share data and data permissions between users — for example, between a clinician and a patient — the user that logged in and performed the device upload may not be the PwD whose data is being uploaded.

---

## Computer Time (`computerTime`)

The computer time field encodes the local time at upload with no timezone offset information (Tidepool stores timezone separately). We store this field to audit and/or detect the correspondence between the user's browser time and the timezone they selected at the time of upload. If the user selected the *correct* timezone for their browser, then the timezone will be converted to UTC Zulu time and then again to computer time (which should match the selected timezone). If, however, the user selected a *different* timezone from that effective in their browser, the computer time and timezone will not match.

There are some cases where it is perfectly justified to select a timezone that does not reflect the browser's current timezone. For example, some insulin pump users do not change the time on their devices when traveling for short periods of time across many timezones. When uploading a device, a user should *always* choose the timezone that aligns with the most recent data on the device and therefore (in the previous example) will not match the local browser timezone.

---

## Device Manufacturers (`deviceManufacurers`)

To avoid confusion resulting from referring to a single manufacturer with more than one name — for example, using both "Minimed" and "Medtronic" interchangeably — Tidepool restricts device manufacturer string "tags" to those detailed in the quick summary above and enforces exact string matches (including casing).

Device manufacturers is an array of one or more string tags because  some devices are the result of manufacturer collaboration, such as the Tandem G4 insulin pump with CGM integration (a collaboration between Tandem and Dexcom).

---

## Device Model (`deviceModel`)

The device model is a non-empty string that encodes the model of device. We endeavor to match each manufacturer's standard for how they represent model name in terms of casing, whether parts of the name are represented as one word or two, etc.

---

## Device Serial Number (`deviceSerialNumber`)

The device serial number is a string that encodes the serial number of the device.

<!-- theme: info -->

> Even if a manufacturer only uses digits in its serial numbers, the serial number should be stored as a string regardless.

Having the device serial number is extremely important (especially for clinical studies) and should be included whenever possible.  However, if the device serial number is unknown, the device serial number may be an empty string.

---

## Device Tags (`deviceTags`)

The device tags array should be fairly self-explanatory as an array of tags indicating the function/s of a particular device. For example, the Insulet OmniPod insulin delivery system has the tags "bgm" and "insulin-pump" since the PDM (personal diabetes monitor) is both an insulin pump controller and includes a built-in blood glucose monitor.

---

## Time Processing (`timeProcessing`)

For data auditing purposes, Tidepool stores a string encoding the type of algorithm used to generate the time, timezone offset, and other related fields from the local device time. At present, there are only three options for this value:

* **Across-the-board-timezone for devices** (all BGMs, for example) that cannot have their device time values "bootstrapped" to a UTC time value. In such cases, we apply a single user-selected timezone to every device time "across the board" to generate the time value.
* **UTC-bootstrapping for devices** (most insulin pumps and CGMs) where we use a combination of the user-selected timezone (at time of upload), the most recent timestamp on the device, and the history of display time changes on the device to infer the correct time value for each record.
* **None** for data sources that already include a UTC-anchored time value. Currently, the only data source for which this is true is Dexcom G5 data coming through Apple's iOS HealthKit integration.

---

## Timezone (`timezone`)

The timezone is the timezone selected by the user manually in the Chrome uploader at the time of upload, or (in the case of Dexcom G5 data from HealthKit), the timezone reported by the mobile device at the time of upload.

<!-- theme: info -->

> Tidepool uses the Moment Timezone library for the implementation of both UTC-bootstrapping (in Tidepool Uploader) and in Tidepool Web. Moment Timezone includes a copy of the IANA timezone database and is updated frequently, but as Tidepool does not always reguarly update dependencies, the possible values of this field are limited to the string timezone names recognized by the IANA timezone database (included in Tidepool's current version of Moment Timezone).

---

## Upload ID (`uploadId`)

The upload ID is generated and returned by Platform when opening an upload session. The upload ID should be used as part of the URI when adding new data.

Upload ID should *not* be used in any POST bodies when uploading to Platform.

---

## Version (`version`)

A string identifying the software version of the uploading client. For Tidepool Uploader, this will be a semver (e.g. `1.25.2`). For other uploading clients such as Tidepool iOS applications, the format includes the namespace and semver of the app (e.g. `org.tidepool.blipnotes:1.25:2`).

---

## Examples

```json title="Example (client)" lineNumbers=true
{
    "type": "upload",
    "byUser": "154bb78230",
    "computerTime": "2016-06-27T18:09:55",
    "deviceManufacturers": "Tandems",
    "deviceModel": "Devicey McDeviceface",
    "deviceSerialNumber": "11359410",
    "deviceTags": [
        "bgm",
        "cgm"
    ],
    "timeProcessing": "across-the-board-timezone",
    "timezone": "Europe/London",
    "uploadId": "SampleUploadId",
    "version": "0.100.0",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2016-06-27T18:09:55",
    "guid": "e46ceaf2-e6af-4eb2-9583-3b6095f44474",
    "id": "eed794bbf9ec4b118f5e4c158216d45d",
    "time": "2016-06-28T01:09:55.131Z",
    "timezoneOffset": -420
}
```

```json title="Example (ingestion)" lineNumbers=true
{
    "type": "upload",
    "byUser": "eda1e15c6a",
    "computerTime": "2016-06-27T18:09:55",
    "deviceManufacturers": "Tandems",
    "deviceModel": "Devicey McDeviceface",
    "deviceSerialNumber": "B97B6D59",
    "deviceTags": [
        "bgm",
        "cgm"
    ],
    "timeProcessing": "utc-bootstrapping",
    "timezone": "Europe/London",
    "uploadId": "SampleUploadId",
    "version": "0.100.0",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2016-06-27T18:09:55",
    "time": "2016-06-28T01:09:55.132Z",
    "timezoneOffset": -420
}
```

```json title="Example (storage)" lineNumbers=true
{
    "type": "upload",
    "byUser": "e9c6044f37",
    "computerTime": "2016-06-27T18:09:55",
    "deviceManufacturers": "Tandems",
    "deviceModel": "Devicey McDeviceface",
    "deviceSerialNumber": "59579660",
    "deviceTags": [
        "bgm",
        "cgm"
    ],
    "timeProcessing": "utc-bootstrapping",
    "timezone": "Europe/London",
    "uploadId": "SampleUploadId",
    "version": "0.100.0",
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2016-06-28T01:10:00.132Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2016-06-27T18:09:55",
    "guid": "42b5f8b1-699a-4c15-ab62-33934791ea7b",
    "id": "451beb9d69b64bc2a60a1696559f94d1",
    "time": "2016-06-28T01:09:55.132Z",
    "timezoneOffset": -420
}
```

---

## Keep Reading

* [Bolus Calculator](./calculator.md)
* [Common Fields](../../common-fields.md)
* [Datetime Guide](../../../datetime.md)
* [Diabetes Data Types](../../data-types.md)
* [Pump Settings](../pump-settings.md)
* [Self-Monitored Glucose (SMBG)](./smbg.md)
* [Units](../../units.md)
