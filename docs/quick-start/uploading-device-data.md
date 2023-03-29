<!-- omit in toc -->
# Uploading Device Data

<!-- omit in toc -->
## Table of Contents

1. [Choosing A Client Name](#choosing-a-client-name)
2. [Data Upload Session Types](#data-upload-session-types)
   1. [Normal Upload Sessions (`normal`)](#normal-upload-sessions-normal)
   2. [Continuous Upload Sessions (`continuous`)](#continuous-upload-sessions-continuous)
3. [Upload Deduplicators](#upload-deduplicators)
4. [Keep Reading](#keep-reading)

---

## Choosing A Client Name

You will need to choose a "client name" for your app. A "client name" is used to identify data in the Tidepool Platform that your app has created.
We recommend using [reverse DNS notation](https://en.wikipedia.org/wiki/Reverse_domain_name_notation) to identify your app/service. For example:

* `com.mycompany.TidepoolUploader` (company)
* `com.github.pazaan.600SeriesAndroidUploader` (personal project)

Your client will also need to provide a [Semantic Version](https://semver.org/) to identify which version of your app/service is uploading data.

---

## Data Upload Session Types

Platform has two data upload modes:

* [Normal](./uploading-device-data/normal.md)
* [Continuous](./uploading-device-data/continuous.md)

You will need to determine which mode is the best to use for your upload implementation.

---

### Normal Upload Sessions (`normal`)

A normal upload session is used for "bulk" uploads.

An example of this is the Tidepool Uploader: When you use Tidepool Uploader, you are connecting a device to your computer, and using the Tidepool Uploader to read a large set of historical data from the device. Tidepool Uploader will create a normal upload session, and close that session when all data for that diabetes device has been uploaded.

Subsequent uploads for the same device will create a _new_ normal upload session, and this data will be deduplicated against any previous sessions.

---

### Continuous Upload Sessions (`continuous`)

A continuous upload session is used for devices that have the ability to connect to the internet (either directly or via a tethered device), and frequently upload data to the Tidepool platform.

An example of this is Tidepool Mobile, which uploads updates from the Dexcom or Loop apps (via HealthKit) every 5 minutes.

You are still able to use a continuous upload session to upload a large amount of historical data.

---

## Upload Deduplicators

TODO: Section on deduplicators goes here.

---

## Keep Reading

* [Using A Continuous Upload Session](./uploading-device-data/continuous.md)
* [Using A Normal Upload Session](./uploading-device-data/normal.md)
