# Reported State (`reportedState`)

Reported states that can have an impact on blood glucose. A reported state consists of an array of one or more states, where each reported state consists of a named `state`:

- `alcohol`, 
- `cycle`, 
- `hyperglycemiaSymptoms`, 
- `hypoglycemiaSymptoms`, 
- `stres`, 
- `illness` or 
- `other`
  
  and a `severity` from 0 to 10. In the case of state `other`, a text field `stateOther` (0-100 characters) describes the state. 

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../reference/data/models/state/reportedstate.v1.yaml"
  }
/%}

## Examples

```json {% title="Example (reported state)" %}
{
    "type": "reportedState",
    "clockDriftOffset": 0,
    "conversionOffset": 0,
    "createdTime": "2025-05-14T08:17:13.453Z",
    "deviceId": "DevId0987654321",
    "deviceTime": "2025-05-14T18:17:08",
    "guid": "96013c51-c2f5-4557-ad0b-479151cf0512",
    "id": "6e3ea4734056463f84f6be47621d21d7",
    "time": "2025-05-14T08:17:08.453Z",
    "timezoneOffset": 600,
    "uploadId": "SampleUploadId",
    "states": [
      {
        "severity": 5,
        "state": "alcohol"
      }
    ]
}
```