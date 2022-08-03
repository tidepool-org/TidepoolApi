# Uploading Data in a Continuous Session (`continuous`)

## Table of Contents

1. [Open A New Continuous Session](#open-a-new-continuous-session)
2. [Find An Existing Continuous Session](#find-an-existing-continuous-session)
3. [Upload Device Data To The Open Session](#upload-device-data-to-the-open-session)
4. [Keep Reading](#keep-reading)

---

<!-- theme: success -->

> ### Are You Authenticated?
>
> Make sure that you have a [Tidepool session token](../../quick-start.md#authentication) before trying to fetch data.

---

## Open A New Continuous Session

If you have previously opened a continuous session, [skip ahead](#find-an-existing-continuous-session). Otherwise, issue the following command:

```shell
curl -X POST https://int-api.tidepool.org/v1/users/<subject-userid>/data_sets \
  -H 'X-Tidepool-Session-Token: <your-session-token>' \
  --data-binary '{ "client": { "name": "<client-name>", "version": "<client-version>" }, "dataSetType": "continuous", "deduplicator": { "name": "org.tidepool.deduplicator.dataset.delete.origin" } }'
```

```json http
{
  "method": "post",
  "url": "https://int-api.tidepool.org/v1/users/{$$.env.subject-userid}/data_sets",
  "query": null,
  "headers": {
    "X-Tidepool-Session-Token": "{$$.env.x-tidepool-session-token}",
    "Content-Type": "application/json"
  },
  "body": "{ \"client\": { \"name\": \"{$$.env.client-name}\", \"version\": \"{$$.env.client-version}\" }, \"dataSetType\": \"continuous\", \"deduplicator\": { \"name\": \"org.tidepool.deduplicator.dataset.delete.origin\" } }"
}
```

This will return an HTTP response with a JSON body. You should store **the value of the upload session ID** to use when uploading data to this session.

```json
{
  "data": {
    "createdTime": "2019-08-29T08:05:25.851Z",
    "deduplicator": {
      "name": "org.tidepool.deduplicator.dataset.delete.origin",
      "version": "1.0.0"
    },
    "id": "<upload-session-id>",
    "modifiedTime": "2019-08-29T08:05:25.889Z",
    "type": "upload",
    "uploadId": "<upload-session-id>",
    "client": {
      "name": "<client-name>",
      "version": "<client-version>"
    },
    "dataSetType": "continuous"
  }
}
```

---

## Find An Existing Continuous Session

If you have previously opened a continuous session, you can use this request to get the session ID if you haven't cached it somewhere (if you already know your session ID, [skip ahead](#upload-device-data-to-the-open-session)):

```shell
curl https://int-api.tidepool.org/v1/users/<subject-userid>/data_sets?client.name=<client-name> -H 'X-Tidepool-Session-Token: <your-session-token>'
```

```json http
{
  "method": "get",
  "url": "https://int-api.tidepool.org/v1/users/{$$.env.subject-userid}/data_sets",
  "query": {
    "client.name": "<client-name>"
  },
  "headers": {
    "X-Tidepool-Session-Token": "{$$.env.x-tidepool-session-token}",
    "Content-Type": "application/json"
  },
  "body": null
}
```

This will return an HTTP response with a JSON body. You should temporarily store the value of the upload session ID you intend to write data to.

```json
[
  {
    "client": {
      "name": "<client-name>",
      "version": "<client-version>"
    },
    "createdTime": "2019-08-28T02:54:41.869Z",
    "dataSetType": "continuous",
    "deduplicator": {
      "name": "org.tidepool.deduplicator.dataset.delete.origin",
      "version": "1.0.0"
    },
    "id": "<upload-session-id>",
    "modifiedTime": "2019-08-28T02:54:41.896Z",
    "type": "upload",
    "uploadId": "<upload-session-id>"
  }
]
```

---

## Upload Device Data To The Open Session

Upload data in chunks of 1,000 records:

```shell
curl 'https://int-api.tidepool.org/dataservices/v1/datasets/<upload-session-id>/data' –H 'X-Tidepool-Session-Token: <your-session-token>' –H 'Content-Type: application/json' --data-binary '[<array of diabetes device data objects>]'
```

```json http
{
  "method": "post",
  "url": "https://int-api.tidepool.org/dataservices/v1/datasets/{$$.env.upload-session-id}/data",
  "headers": {
    "X-Tidepool-Session-Token": "{$$.env.x-tidepool-session-token}",
    "Content-Type": "application/json"
  },
  "body": "[<{$$.env.array} of diabetes device data objects>]"
}
```

The body for this HTTP POST should be JSON, and follow the format outlined in the [diabetes data types](./device-data/data-types.md) documentation.

When you upload data for a continuous session, you will also need to provide an "origin" field for every data object, that contains at least an ID, name and type. The ID is a unique identifier within your upload session that allows you to identify that data point.

As an example, uploading a couple of continuous blood glucose (CBG) records might look like this:

```shell
curl 'https://int-api.tidepool.org/dataservices/v1/datasets/<upload-session-id>/data' -H 'X-Tidepool-Session-Token: <your-session-token>' -H 'Content-Type: application/json' --data-binary '[{"time":"2017-02-05T13:26:51.000Z","timezoneOffset":660,"clockDriftOffset":0,"conversionOffset":0,"deviceTime":"2017-02-06T00:26:51","deviceId":"MMT-1711:12345678","type":"cbg","value":119,"units":"mg/dL","origin":{"id":"06b10116-e85c-4abe-8a35-4eca838bd484","name":"com.apple.HealthKit","type":"service"},"payload":{"interstitialSignal":24.98}},{"time":"2017-02-05T13:31:51.000Z","timezoneOffset":660,"clockDriftOffset":0,"conversionOffset":0,"deviceTime":"2017-02-06T00:31:51","deviceId":"MMT-1711:12345678","type":"cbg","value":120,"units":"mg/dL","origin":{"id":"1c26886a-ae52-4e43-84cf-5047afe3efc3","name":"com.apple.HealthKit","type":"service"},"payload":{"interstitialSignal":25.22}}]'
```

<!-- theme: error -->

> Do not close the session after you have uploaded your data, as you would for a normal session type. If you _do_ close a continuous session, you will not be able to write to it, and will need to open a new one.

---

## Keep Reading

* [Diabetes Data Types](./device-data/data-types.md)
* [Diabetes Device Data Model](./device-data.md)
* [Using A Normal Upload Session](./quick-start/uploading-device-data/normal.md)
