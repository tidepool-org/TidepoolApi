# Fetching Device Data

## Table of Contents

1. [Fetch device data](#fetch-device-data)
2. [Query parameters](#query-parameters)
3. [Fetch Dexcom CGM data](#fetch-dexcom-cgm-data)
4. [Keep Reading](#keep-reading)

---

<!-- theme: success -->

> ### Are You Authenticated?
>
> Make sure that you have a [Tidepool session token](../quick-start.md#authentication) before trying to fetch data.

---

## Fetch Device Data

To fetch data for authorized accounts, issue the following command:

```shell
curl -s -X GET -H "X-Tidepool-Session-Token: <your-session-token>" -H "Content-Type: application/json" "https://int-api.tidepool.org/data/<subject-userid>"
```

```json http
{
  "method": "get",
  "url": "https://int-api.tidepool.org/data/<{$$.env.subject-userid}>",
  "headers": {
    "X-Tidepool-Session-Token": "{$$.env.x-tidepool-session-token}",
    "Content-Type": "application/json"
  },
}
```

Subject user ID is the Tidepool user ID of the user whose data you want to view.

---

## Query Parameters

You can narrow the fetch query by specifying a type, sub-type and/or date query parameter to Platform's URL. Comma-separated lists will return data matching any of the specified types (see [GitHub](http://github.com/tidepool-org/tide-whisperer/blob/master/tide-whisperer.go#L193) comments for more detail):

<!-- title: Query Parameters -->

| Parameter | Type | Effect | Example
| --- | --- | --- | --- |
| Device ID | String | Only objects with a device ID field matching the specified device ID param will be returned. | E.g. `/data/userid?deviceId=abcdef0123456789`
| End date | String (in ISO-8601 date/time format) | Only objects with time field less than or equal to end date will be returned. | E.g. `?endDate=2015-10-10T15:00:00.000Z`
| Latest data | Boolean | Returns only the most recent results for each type matching the results filtered by the other query parameters. | All types: `?latest=true` or single type: `?latest=true&type=cbg`
| Start date | String (in ISO-8601 date/time format) | Only objects with time field equal to or greater than start date will be returned. | E.g. `?startDate=2015-10-10T15:00:00.000Z`
| Sub-type | String | Only objects with a subtype field matching the specified subtype param will be returned. | Single type: `/data/userid?subtype=physicalactivity` Comma-separated list: `/data/userid?subtype=physicalactivity,steps`
| Type | String (data model type) |  Only objects with a type field matching the specified type param will be returned. | Single type: `/data/<userid>?type=smbg` Comma-separated list: `data/<userid>?type=smgb,cbg`
| Upload ID | String | Only objects with an upload ID field matching the specified upload ID param will be returned. If upload ID is specified, ignore the “special” filters below. | E.g. `/data/userid?uploadId=0123456789abcdef`

In addition, there are several “special” parameters that have an effect on the data that is returned depending on more detailed internal business logic.

<!-- title: Additional Query Parameters -->

| Parameter | Type | Effect | Example
| --- | --- | --- | --- |
| Carelink | Boolean | Return data from the now-deprecated CareLink import, unless data for the same time period has been uploaded using the Uploader (the device manufacturers field contains the string Medtronic). | E.g. `/data/userid?carelink=true`
| Dexcom | Boolean | Return CGM data from *only* the Dexcom API, even if other CGM data exists from other sources. | E.g. `/data/userid?dexcom=true`
| Medtronic | Boolean | Return CGM, Basal and Bolus data from Medtronic Uploads, provided that data exists after `2017-09-01`. Unless data from a Medtronic device has been uploaded by Loop via HealthKit (`origin.payload.device.manufacturer` is Medtronic), and that data exists after `2017-09-01`. | E.g. `/data/userid?medtronic=true`

### Example

To fetch just the pump settings for Jill Jellyfish, use:

```shell
curl -s -X GET -H "X-Tidepool-Session-Token: <your-session-token>" -H "Content-Type: application/json" "https://int-api.tidepool.org/data/5d509deb6b?type=pumpSettings"
```

```json http
{
  "method": "get",
  "url": "https://int-api.tidepool.org/data/{$$.env.subject-userid}",
  "query": {
    "type": "pumpSettings"
  },
  "headers": {
    "X-Tidepool-Session-Token": "{$$.env.x-tidepool-session-token}",
    "Content-Type": "application/json"
  },
  "body": null
}
```

<!-- theme: info -->

> All glucose data in Tidepool is stored in mmol/L. To convert to mg/dL, multiply by 18.01559.

---

## Fetch Dexcom CGM Data

Tidepool gives users the ability to [link their Dexcom account](https://godoc.org/github.com/tidepool-org/shoreline/oauth2) to their Tidepool account to fetch Dexcom data. This creates the possibility of duplicate or overlapping data if the user is also using Tidepool Mobile or Tidepool Uploader to upload their Dexcom data.

If the standard GET data Tidepool API is used, then only Dexcom API CGM data will be returned within this time range, and any other CGM data from any other source (Tidepool Uploader, HealthKit via Tidepool Mobile, etc.) will only be returned outside of this time range.

So, you have three time ranges that apply here:

<!-- title: Time Ranges -->

| Start Time | End Time | CGM Data Returned
| --- | --- | --- |
| Beginning of Time | Dexcom API Earliest Data Time | All CGM Data
| Dexcom API Earliest Data Time | Dexcom API Latest Data Time |   Only Dexcom API CGM Data
| Dexcom API Latest Data Time | End of Time | All CGM data

However, if you use the standard GET data Tidepool API, but add the dexcom true (`"?dexcom=true"`) request flag, then it will return all CGM data from all sources, regardless of the Dexcom API state.

---

## Keep Reading

* [Command Line Data Tools](http://github.com/tidepool-org/command-line-data-tools)
* [Diabetes Device Data Model](./device-data)
* [Fetching User Notes](./quick-start/notes.md)
* [Uploading Device Data](./quick-start/uploading-device-data.md)
