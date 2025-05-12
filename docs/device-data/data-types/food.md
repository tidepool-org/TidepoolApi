<!-- omit in toc -->
# Food Consumption (`food`)

```yaml json_schema
$ref: '../../../reference/data/models/food/food.v1.yaml'
```

This type is used to convey information about food consumption.

## Examples

```json {% title="Example (food consumption)" %}
{
    "type": "food",
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
    "amount": {
      "value": 5,
      "units": "g"
    },
    "brand": "Oreo",
    "code": "12345",
    "meal": "snack",
    "name": "cookies!"
}
```
