<!-- omit in toc -->
# Uploading Data in a Normal Session (`normal`)

<!-- omit in toc -->
## Table of Contents

1. [Open A Normal Session](#open-a-normal-session)
2. [Upload Device Data To The Open Session](#upload-device-data-to-the-open-session)
3. [Close The Upload Session](#close-the-upload-session)
4. [Keep Reading](#keep-reading)

---

<!-- theme: success -->

> ### Are You Authenticated?
>
> Make sure that you have a [Tidepool session token](../../quick-start.md#authentication) before trying to fetch data.

---

## Open A Normal Session

The body for this HTTP POST should be JSON, and follow the format outlined in the [diabetes data types](../../device-data/data-types.md) documentation.

```json http
{
  "method": "post",
  "url": "https://int-api.tidepool.org/dataservices/v1/users/{userId}/data_sets",
  "query": null,
  "headers": {
    "X-Tidepool-Session-Token": "{sessionToken}",
    "Content-Type": "application/json"
  },
  "body": {
  }
}
```

<!-- theme: warning -->

> The upload ID field should not be used in the POST body when using these APIs. They are used by an older upload service. In these APIs, the upload ID is generated when starting an upload session, and the ID should only be used as part of the upload URI, not in the POST body.

As an example, creating a new dataset using the `org.tidepool.deduplicator.device.deactivate.hash` deduplicator might look like this:

```json http
{
  "method": "post",
  "url": "https://int-api.tidepool.org/dataservices/v1/users/{userId}/data_sets",
  "query": null,
  "headers": {
    "X-Tidepool-Session-Token": "{sessionToken}",
    "Content-Type": "application/json"
  },
  "body": {
    "client": {
      "name": "{clientName}",
      "version": "{clientVersion}"
    },
    "dataSetType": "normal",
    "deduplicator": {
      "name": "org.tidepool.deduplicator.device.deactivate.hash"
    },
    "deviceManufacturers": [
      "DeviceCorp"
    ],
    "deviceModel": "Devicey McDeviceface",
    "deviceSerialNumber": "B97B6D59",
    "deviceTags": [
      "bgm",
      "cgm",
      "insulin-pump"
    ],
    "timeProcessing": "none",
    "timezone": "Europe/London",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2016-06-27T18:09:55",
    "time": "2016-06-28T01:09:55.132Z",
    "timezoneOffset": -420
  }
}
```

This will return an HTTP response with a JSON body. You should temporarily store **the value of the upload session ID** to upload data for this session.

```json title="Sample Response" lineNumbers=true
{
  "data": {
    "createdTime": "2017-02-06T02:37:46Z",
    "createdUserId": "{userId}",
    "type": "upload",
    "uploadId": "{uploadSessionId}",
              …
  },
  "meta": {
    "trace": {
      "request": "{traceRequestId}"
    }
  }
}
```

---

## Upload Device Data To The Open Session

Upload data to Platform in chunks of 1,000 records.

```json http
{
  "method": "post",
  "url": "https://int-api.tidepool.org/dataservices/v1/datasets/{uploadSessionId}/data",
  "query": null,
  "headers": {
    "X-Tidepool-Session-Token": "{sessionToken}",
    "Content-Type": "application/json"
  },
  "body": [
    // array of diabetes data objects
  ]
}
```

The body for this HTTP POST should be JSON, and follow the format outlined in the [diabetes data types](../../device-data/data-types.md) documentation.

As an example, uploading a couple of continuous blood glucose (CBG) records might look like this:

```json http
{
  "method": "post",
  "url": "https://int-api.tidepool.org/dataservices/v1/datasets/{uploadSessionId}/data",
  "query": null,
  "headers": {
    "X-Tidepool-Session-Token": "{sessionToken}",
    "Content-Type": "application/json"
  },
  "body": [
    {
      "time": "2017-02-05T13:26:51.000Z",
      "timezoneOffset": 660,
      "clockDriftOffset": 0,
      "conversionOffset": 0,
      "deviceTime": "2017-02-06T00:26:51",
      "deviceId": "MMT-1711:12345678",
      "type": "cbg",
      "value": 119,
      "units": "mg/dL",
      "payload": {
        "interstitialSignal": 24.98
      }
    },
    {
      "time": "2017-02-05T13:31:51.000Z",
      "timezoneOffset": 660,
      "clockDriftOffset": 0,
      "conversionOffset": 0,
      "deviceTime": "2017-02-06T00:31:51",
      "deviceId": "MMT-1711:12345678",
      "type": "cbg",
      "value": 120,
      "units": "mg/dL",
      "payload": {
        "interstitialSignal": 25.22
      }
    }
  ]
}
```

---

## Close The Upload Session

```json http
{
  "method": "put",
  "url": "https://int-api.tidepool.org/dataservices/v1/datasets/{uploadSessionId}",
  "query": null,
  "headers": {
    "X-Tidepool-Session-Token": "{sessionToken}",
    "Content-Type": "application/json"
  },
  "body": {
    "dataState": "closed"
  }
}
```

<!-- theme: error -->

> If you do not close a normal upload session, the data you uploaded will _not_ be returned from Platform [when you fetch data](../fetching-device-data.md). Make sure to close your normal upload sessions when they're finished.

---

## Keep Reading

* [Diabetes Data Types](../../device-data/data-types.md)
* [Diabetes Device Data Model](../../device-data.md)
* [Using A Continuous Upload Session](./continuous.md)
