<!-- omit in toc -->
# Sensor Event (`sensorEvent`)

---

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../../reference/data/models/deviceevent/sensor.v1.yaml"
  }
/%}

---

```json {% title="Example" %}
{
  "type": "deviceEvent",
  "subType": "sensorEvent",
  "eventType": "expired",
  "clockDriftOffset": 0,
  "conversionOffset": 0,
  "deviceId": "DevId0987654321",
  "deviceTime": "2018-05-14T18:17:08",
  "time": "2018-05-14T08:17:08.276Z",
  "timezoneOffset": 600,
  "uploadId": "SampleUploadId"
}
```
