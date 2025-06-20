<!-- omit in toc -->
# Device Settings Change (`settingsChange`)

---

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../../reference/data/models/deviceevent/settingschange.v1.yaml"
  }
/%}

An event that occurs when a device has switched to a different setting.

---

```json {% title="Example" %}
{
  "type": "deviceEvent",
  "subType": "settingsChange",
  "bgTarget": {
    "from": "Standard",
    "to": "Workout"
  },
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2018-05-14T18:17:08",
  "time": "2018-05-14T08:17:08.276Z",
  "timezoneOffset": 600,
  "uploadId": "SampleUploadId"
}
```
