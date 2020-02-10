# Getting Started

<!-- theme: info -->

> ### Prerequisites
> Before you begin, you will need to create a [Tidepool user account](http://int-app.tidepool.org/signup). It's free and should take you less than two minutes. You can also download [curl](http://curl.haxx.se/download.html) or [Postman](http://app.getpostman.com/run-collection/9b665f2fb9a8a483bf30?via=clientlibraries) onto your computer (this isn't strictly required but is strongly encouraged).

---

## Table of contents

1. [Authentication](#authentication)
2. [Access user accounts](#access-user-accounts)
3. [Keep reading](#keep-reading)

---

## Authentication

To get access to your diabetes data, you will  need to get an **authorization session token** using your master account credentials. To do this, issue the following command through curl or Postman (NB: if you're doing this through the in-built HTTP request maker, you will need to go into the Auth tab and hit "update request" to post successfully):

```
curl -i -X POST -u [your account email]:[your account password] https://int-api.tidepool.org/auth/login 
```

```yaml http
{
  "method": "post",
  "url": "https://int-api.tidepool.org/auth/login"
}
```

This will return an HTTP response that looks like this:

```
access-control-allow-headers: authorization, content-type, x-tidepool-session-token
access-control-allow-methods: GET, POST, PUT
x-tidepool-session-token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkdXIiOjIuNTkyZSswNiwiZXhwIjoxNDcxMTM0MzIzLCJzdnIiOiJubyIsInVzciI6IjU0YzkwZmIzMjUifQ.bbkzG_rwp9IVMI3HVYm_ct8mMW_YTnTALUW12345678
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

```
curl -s -X GET -H "x-tidepool-session-token: <your-session-token>" -H "Content-Type: application/json" 'https://int-api.tidepool.org/metadata/users/<your-userid>/users'
```