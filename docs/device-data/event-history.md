# Event History

<!-- theme: warning -->

> This is a **proposed** change. It has not been implemented yet.

## Proposal

* Use [JSON Patch](http://jsonpatch.com/) to keep event history
* It can be applied to any of Tidepool's data base data models
	* It's up to the server to reject invalid event patch requests

> **TBD:** Since we want event history to be immutable, we are adding the event history to the original event. Since we are not actually "changing" the original event, but providing a change history, we may not want to use the HTTP `PATCH` verb. We may want to make a new endpoint that "adds" history to an existing data event.

Here is an example of a carb event that was initially a carb entry of 40g, that was changed to 60g 15 minutes later:

```json
{
  "id": "77d722a44fa0055b20c9b988c078766f",
  "name": "🍞🧀",
  "nutrition": {
    "carbohydrate": {
      "net": 40,
      "units": "grams",
      "absorptionTime": 10870000
    }
  },
  "history": [
    {
      "time": "2019-08-13T10:05:19.162Z",
      "changes": [
        {
          "op": "replace",
          "path": "/nutrition/carbohydrate/net",
          "value": 60
        }
      ]
    }
  ],
  "time": "2019-08-13T09:50:16.751Z",
  "type": "food",
  "uploadId": "f7825b06f189edf3ef5afc64f07930e1",
  "deviceTime": "2019-08-13T09:50:16.751Z",
  "displayOffset": 600
}
```

Here is an example of a carbohydrate event that was deleted 4 minutes after initial entry:

```json
{
  "id": "77d722a44fa0055b20c9b988c078766f",
  "name": "🍞🧀",
  "nutrition": {
    "carbohydrate": {
      "net": 40,
      "units": "grams",
      "absorptionTime": 10870000
    }
  },
  "history": [
    {
      "time": "2019-08-13T09:54:37.176Z",
      "changes": [
        {
          "op": "delete",
          "path": ""
        }
      ]
    }
  ],
  "time": "2019-08-13T09:50:16.751Z",
  "type": "food",
  "uploadId": "f7825b06f189edf3ef5afc64f07930e1",
  "deviceTime": "2019-08-13T09:50:16.751Z",
  "displayOffset": 600
}
```

Here is an example of a carb event that was initially a carb entry of 40g, that was changed to occur at an earlier time 5 minutes after originally being entered:

```json
{
  "id": "77d722a44fa0055b20c9b988c078766f",
  "name": "🍞🧀",
  "nutrition": {
    "carbohydrate": {
      "net": 40,
      "units": "grams",
      "absorptionTime": 10870000
    }
  },
  "history": [
    {
      "time": "2019-08-13T09:55:19.162Z",
      "changes": [
        {
          "op": "replace",
          "path": "/time",
          "value": "2019-08-13T09:20:32.159Z"
        },
        {
          "op": "replace",
          "path": "/deviceTime",
          "value": "2019-08-13T09:20:32.159Z"
        }
      ]
    }
  ],
  "time": "2019-08-13T09:50:16.751Z",
  "type": "food",
  "uploadId": "f7825b06f189edf3ef5afc64f07930e1",
  "deviceTime": "2019-08-13T09:50:16.751Z",
  "displayOffset": 600
}
```
