# Getting Started

<!-- theme: success -->

> ### Prerequisites
>
> Before you begin, you will need to create a [Tidepool user account](http://int-app.tidepool.org/signup). It's free and should take you less than two minutes. You can also download [curl](http://curl.haxx.se/download.html) or [Postman](http://app.getpostman.com/run-collection/9b665f2fb9a8a483bf30?via=clientlibraries) onto your computer (this isn't strictly required but is strongly encouraged).

### Table of Contents

1. [Authentication](#authentication)
2. [Access user accounts](#access-user-accounts)
3. [Keep reading](#keep-reading)

---

## Authentication

To get access to your diabetes data, you will  need to get an **authorization session token** using your master account credentials. To do this, issue the following command through curl or Postman (NB: if you're doing this through the in-built HTTP request maker, you will need to go into the Auth tab and hit "update request" to post successfully):

```shell
curl -i -X POST -u [your account email]:[your account password] https://int-api.tidepool.org/auth/login
```

```yaml http
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

```
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

## Access user accounts

The following command returns user information associated with the given user ID. This step is only necessary if you have not previously stored the user IDs you wish to access:

```shell
curl -s -X GET -H "X-Tidepool-Session-Token: <your-session-token>" -H "Content-Type: application/json" 'https://int-api.tidepool.org/metadata/users/<your-userid>/users'
```

```yaml http
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

```yaml http
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

```json
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

### Keep reading

* [Fetching device data](./quick-start/fetching-device-data.md)
* [Fetching user notes](./quick-start/notes.md)
* [Uploading device data](./quick-start/uploading-device-data.md)
