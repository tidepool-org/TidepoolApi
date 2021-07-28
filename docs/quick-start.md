# Getting Started

![Tidepool Logo](../assets/images/Tidepool_Logo_Light_Large.png)

## Table of Contents

1. [Authentication](#authentication)
2. [Tracing](#tracing)
3. [Errors](#errors)
4. [Access User Accounts](#access-user-accounts)
5. [Keep Reading](#keep-reading)

---

<!-- theme: success -->

> ### Prerequisites
>
> Before you begin, you will need to create a [Tidepool user account](http://int-app.tidepool.org/signup). It's free and should take you less than two minutes. You can also download [curl](http://curl.haxx.se/download.html) or [Postman](http://app.getpostman.com/run-collection/9b665f2fb9a8a483bf30?via=clientlibraries) onto your computer (this isn't strictly required but is strongly encouraged).

## Authentication

To get access to your diabetes data, you will  need to get an **authorization session token** using your master account credentials. To do this, issue the following command through curl or Postman (NB: if you're doing this through the in-built HTTP request maker, you will need to go into the Auth tab and hit "update request" to post successfully):

```shell
curl -i -X POST -u [your account email]:[your account password] https://int-api.tidepool.org/auth/login
```

```json http
{
  "method": "post",
  "url": "https://int-api.tidepool.org/auth/login",
  "query": null,
  "headers": {
    "Authorization": "Basic bGVubmFydEB0aWRlcG9vbC5vcmc6bk1uN3tYTTIoRnokM0pHQ3o2UUx4aHQ=",
    "Content-Type": "application/json"
  },
  "body": null
}
```

This will return an HTTP response that looks like this:

```http
Access-Control-Allow-Headers: Authorization, Content-Type, X-Tidepool-Session-Token
Access-Control-Allow-Methods: GET, POST, PUT
X-Tidepool-Session-Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkdXIiOjIuNTkyZSswNiwiZXhwIjoxNDcxMTM0MzIzLCJzdnIiOiJubyIsInVzciI6IjU0YzkwZmIzMjUifQ.bbkzG_rwp9IVMI3HVYm_ct8mMW_YTnTALUW12345678
Connection: keep-alive
{
  "emailVerified": true,
  "emails": [
    "demo+intpublicclinic@tidepool.org"
  ],
  "termsAccepted": "2017-08-16T10:30:5607:00",
  "userid": "4533925fea",
  "username": "demo+intpublicclinic@tidepool.org"
}
```

From the response headers, save the **Tidepool session token**. From the response body, save the **user ID**, excluding the quotation marks.

---

## Tracing

All Tidepool API requests may include two HTTP headers to trace requests and 'sessions' of requests throughout the
Tidepool ecosystem:

* The `X-Tidepool-Trace-Request` HTTP header allows for a 1-64 character string value to be associated with all server logging during the request. Typically, a client would generate a unique value and add it to each request. If not specified with the request, then one is generated and returned in the response. The client should capture this header value with any failure for future analysis.
* The `X-Tidepool-Trace-Session` HTTP header allows for a 1-64 character string value to be associated with all server logging during a 'session' of requests. Typically, a client would generate a unique value when a session starts and add it to each request during the session. If not specified by the client on the request, no header is returned in the response. The client should capture this header value with any failure for future analysis.

<!-- theme: info -->

> ### Brevity (headers)
>
> For brevity, these headers are *not* documented for each specific endpoint.

For example, a request with both headers specified:

```http
GET  /v1/users/a43d25a01f/images HTTP/1.1
Host: int-api.tidepool.org
X-Tidepool-Trace-Request: c836ab48d92c4789abb38d759a021b3e
X-Tidepool-Trace-Session: a4928790fbc02cabd749dbc920eb9c73
```

## Errors

The Tidepool API uses [standard HTTP status codes](https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html) to indicate success or failure of any API call. In the case of failure, the body of the response will provide developer guidance in UTF-8 JSON format.

<!-- theme: warning -->

> ### Format
>
> Some Tidepool legacy APIs return the developer guidance in different UTF-8 JSON format.

```json
{
  'code': 'length-out-of-range',
  'title': 'length is out of range',
  'detail': 'length 101 is not less than or equal to 100',
  'source': '/name',
  'metadata': {
    'type': 'image'
  }
}
```

The `code`, `title`, and `detail` fields are required. The `source` and `metadata` fields are optional and are dependent
upon the type and location of the error. The most common failure HTTP status codes are `400`, `401`, `403`, and `404`, but `413`, `429`, and `500` may be used under certain circumstances.

<!-- theme: info -->

> ### Brevity (errors)
>
> For brevity, these errors are *not* documented for each specific endpoint.

---

## Access User Accounts

The following command returns user information associated with the given user ID. This step is only necessary if you have not previously stored the user IDs you wish to access:

```shell
curl -s -X GET -H "X-Tidepool-Session-Token: <your-session-token>" -H "Content-Type: application/json" 'https://int-api.tidepool.org/metadata/users/<your-userid>/users'
```

```json http
{
  "method": "get",
  "url": "https://int-api.tidepool.org/metadata/users/{$$.env.userid}/users",
  "query": null,
  "headers": {
    "X-Tidepool-Session-Token": "{$$.env.x-tidepool-session-token}",
    "Content-Type": "application/json"
  }
}
```

From this list, find the user ID of the patient (or study subject) whose data you wish to fetch. Continuing with our example, we would use:

```shell
curl -s -X GET -H "X-Tidepool-Session-Token: ey...uk" -H "Content-Type: application/json" "https://int-api.tidepool.org/metadata/users/4533925fea/users"
```

```json http
{
  "method": "get",
  "url": "https://int-api.tidepool.org/metadata/users/{$$.env.userid}/users",
  "query": null,
  "headers": {
    "X-Tidepool-Session-Token": "{$$.env.x-tidepool-session-token}",
    "Content-Type": "application/json"
  }
}
```

This request will return something like this:

```json title="Response" lineNumbers
[
  {
    "emailVerified": true,
    "emails": [
      "demo+jill@tidepool.org"
    ],
    "termsAccepted": "2017-08-03T12:19:54-07:00",
    "userid": "5d509deb6b",
    "username": "demo+jill@tidepool.org",
    "trustorPermissions": {
      "view": {}
    },
    "profile": {
      "fullName": "Jill Jellyfish",
      "patient": {
        "birthday": "2000-01-01",
        "diagnosisDate": "2000-01-01",
        "targetDevices": [
          "omnipod",
          "dexcom"
        ],
        "targetTimezone": "US/Pacific"
      }
    }
  },
  {
    "userid": "0223d994e9",
    "trustorPermissions": {
      "custodian": {},
      "upload": {},
      "view": {}
    },
    "profile": {
      "fullName": "Marissa Medpumper",
      "patient": {
        "birthday": "2000-01-17",
        "mrn": "123456-mm",
        "targetDevices": [
          "carelink"
        ],
        "targetTimezone": "US/Pacific"
      }
    }
  }
]
```

As you can see, this example master account has view access for two kinds of user accounts:

1. Jill Jellyfish has a personal account that she has shared with the master account.

2. Marissa Medpumper has a custodial account that was created in-clinic by the master account. Marissa was not invited or has not claimed her personal account, so there is no email associated with the profile.

---

## Keep Reading

* [Fetching device data](./quick-start/fetching-device-data.md)
* [Fetching user notes](./quick-start/notes.md)
* [Uploading device data](./quick-start/uploading-device-data.md)
