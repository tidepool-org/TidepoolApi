# Sensor Event (`sensorEvent`)

```json json_schema
{
  "title": "Sensor event",
  "type": "object",
  "properties": {
    "$ref": "../../../../reference/data/models/devicesensorevent.v1.yaml"
  }
}
```

## Example

```json
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
