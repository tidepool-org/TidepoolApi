# Common Fields

## Table of Contents

1. [Quick summary](#quick-summary)
2. [Clock drift offset](#clock-drift-offset-clockdriftoffset)
3. [Conversion offset](#conversion-offset-conversionoffset)
4. [Created time](#created-time-createdtime)
5. [Device ID](#device-id-deviceid)
6. [Device time](#device-time-devicetime)
7. [GUID](#guid-guid)
8. [ID](#id-id)
9. [Time](#time-time)
10. [Timezone offset](#timezone-offset-timezoneoffset)
11. [Upload ID](#upload-id-uploadid)
12. [Example (all possible fields)](#example-all-possible-fields)

---

## Quick summary

```yaml json_schema
$ref: '../../reference/data/models/base.v1.yaml'
```

---

## Clock Drift Offset (`clockDriftOffset`)

This field is Platform's best effort to convert the device's local [display time](#device-time-devicetime) to UTC. This optional field records the offset from UTC (in milliseconds) resulting from small adjustments a user may make to a device's display time due to "clock drift." See the technical documentation describing ["Bootstrapping to UTC"](../datetime/btutc.md#clock-drift-offset-clockdriftoffset) for more information.

---

## Conversion Offset (`conversionOffset`)

This field is Platform's best effort to convert the device's local [display time](#device-time-devicetime) to UTC. This field records the offset from UTC resulting from *very large* adjustments a user may make due to realizing the device was set to the wrong day, month, or year. See the technical documentation describing ["Bootstrapping to UTC"](../datetime/btutc.md#conversion-offset-conversionoffset) for more information.

---

## Created Time (`createdTime`)

Created time is the machine-time when the event was first ingested into Platform. This is represented as an [ISO 8601-formatted](../datetime/glossary.md#iso-8601) UTC timestamp with a final Z for "Zulu" time.

Example:

* `2015-11-09T03:58:44.584Z`

---

## Device ID (`deviceId`)

A string encoding the device that generated the datum. This should be globally unique to this device and repeatable with each upload. A device make and model with a shortened serial number is a good value to include here.

Examples:

* `InsOmn-240243671` (Insulet OmniPod with serial number 240243671)
* `DexG4RecwitShaSM62228608` (Dexcom G4 receiver with Share, serial number SM62228608)

---

## Device Time (`deviceTime`)

No currently available diabetes device (that Tidepool knows of) stores data in UTC or UTC-anchored time via a timezone offset. This means all diabetes devices currently store the device's display time *at the time the event occurred*. Platform makes a best effort to [convert this device time to UTC](../datetime/btutc.md), but the raw device time is also stored for data-auditing purposes. It is stored in the [ISO 8601 format](../datetime/glossary.md#iso-8601), but without any timezone offset information.

Example:

* `2015-11-08T17:06:53`

---

## GUID (`guid`)

An [RFC 4122](https://www.ietf.org/rfc/rfc4122.txt) version 4 UUID (universally unique identifier), generated using the [node-uuid](https://github.com/broofa/node-uuid) library in [Tidepool Uploader](https://github.com/tidepool-org/uploader) or, if the data is being ingested through Platform, added upon ingestion by the service itself.

See [here](http://github.com/tidepool-org/uploader/blob/master/lib/core/api.js) for Tidepool Uploader implementation and `app/uuid.go` for Platform ingestion implementation.

Example:

* `6380d89e-1894-49de-bdaf-cb1e8c163dec`

---

## ID (`id`)

The IDs generated for each event by Platform are simply [RFC 4122](https://www.ietf.org/rfc/rfc4122.txt) version 4 UUIDs with the - characters deleted. This provides a backwards compatibility with the format of the earlier jellyfish-generated IDs, which were alphanumeric.

Example:

* `c4c31493417b4c6d968b72f08e6b3712`

<!-- theme: info -->

> IDs are not deterministically generated from the content of events and are therefore not useful for deduplication.

---

## Time (`time`)

An [ISO 8601-formatted](../datetime/glossary.md#iso-8601) timestamp including either a timezone offset from UTC or converted to UTC and formatted with a final Z for "Zulu" time.

This field is Platform's best effort to convert the device's local [display time](#device-time-devicetime) to UTC. See ["Bootstrapping to UTC"](../datetime/btutc.md) for more information.

Examples:

* `2015-11-08T17:06:53-08:00` *(timezone offset from UTC)*
* `2015-11-09T01:06:53.555Z` *("Zulu" time formatting)*

---

## Timezone Offset (`timezoneOffset`)

This field is Platform's best effort to convert the device's local [display time](#device-time-devicetime) to UTC. Timezone offset encodes the offest (in minutes from UTC) to convert the UTC timestamp back to local display time. See ["Bootstrapping to UTC"](../datetime/btutc.md) for more information.

Examples:

* `0` (timezone offset for UTC)
* `-480` (timezone offset for Pacific Standard Time in the U.S.)
* `60` (timezone offset for British Summer Time)

---

## Upload ID (`uploadId`)

An upload identifier. This field should be the upload ID of the corresponding upload record. Currently, upload IDs are generated in [Tidepool Uploader](https://github.com/tidepool-org/uploader/blob/master/lib/core/api.js) as a hash of various pieces of upload session metadata.

<!-- theme: warning -->

> Upload ID does *not* figure in the calculations of an event record's ID. This ID is used to prevent storage of multiple copies of the same event. This means that multiple attempts to upload the same event record will nevertheless result in the same ID.

---

## Example (All Possible Fields)

```json
{
    "_active": true,
    "_groupId": "abcdef",
    "_schemaVersion": 0,
    "_version": 0,
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:12.734Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:07",
    "guid": "33b8f139-50e4-49d6-b9eb-44d70cc05abc",
    "id": "47a2c4c1435a41bc83aba48797ed5cb3",
    "time": "2018-05-14T08:17:07.734Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId"
}
```
