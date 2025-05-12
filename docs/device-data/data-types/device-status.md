<!-- omit in toc -->
# Device Status (`deviceStatus`)

```yaml json_schema
$ref: '../../../reference/data/models/deviceevent/status.v1.yaml'
```

This type is used to convey the status of a device.

## Examples

```json {% title="Example (insulin pump)" %}
{
    "type": "deviceStatus",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2018-05-14T08:17:13.453Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "96013c51-c2f5-4557-ad0b-479151cf0512",
    "id": "6e3ea4734056463f84f6be47621d21d7",
    "time": "2018-05-14T08:17:08.453Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId",
    "deviceType": "pump",
    "status": [
      {
        "battery": {
          "value": 50,
          "unit": "percent"
        }
      },
      {
        "reservoirRemaining": {
          "amount": 170,
          "unit": "Units"
        }
      },
      {
        "alerts": [
          "Something bad is happening with the pump"
        ]
      }
    ]
}
```

```json {% title="Example (AID)" %}
{
    "type": "deviceStatus",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "deviceId": "DevId0987654321",
    "deviceTime": "2018-05-14T18:17:08",
    "guid": "96013c51-c2f5-4557-ad0b-479151cf0512",
    "id": "6e3ea4734056463f84f6be47621d21d7",
    "time": "2018-05-14T08:17:08.453Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId",
    "deviceType": "aid",
    "status": [
      {
        "battery": {
          "unit": "percent",
          "value": 75
        }
      },
      {
        "signalStrength": {
          "unit": "dB",
          "value": -65
        }
      },
      {
        "alerts": [
          "Loop tried to bolus, but didn't hear back from the pump"
        ]
      },
      {
        "forecast": {
          "startTime": "2018-05-14T08:18:00.000Z",
          "timeScale": 300000,
          "type": "bloodGlucose",
          "unit": "mg/dL",
          "values": [
            121,
            123,
            125,
            128,
            131,
            135,
            132,
            130
          ]
        }
      },
      {
        "forecast": {
          "startTime": "2018-05-14T08:18:00.000Z",
          "timeScale": 300000,
          "type": "carbsOnBoard",
          "unit": "g",
          "values": [
            40,
            38,
            36,
            35,
            34,
            33
          ]
        }
      }
    ],
    "version": "1.0.2"
}
```
