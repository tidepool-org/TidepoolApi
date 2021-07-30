# Fetching User Notes

You can fetch user notes by issuing the following command:

```shell
curl -s -X GET -H "X-Tidepool-Session-Token: <your-session-token>" -H "Content-Type: application/json" "https://int-api.tidepool.org/message/notes/<subject-userid>"
```

```json http
{
  "method": "get",
  "url": "https://int-api.tidepool.org/message/notes/<{$$.env.subject-userid}>",
  "headers": {
    "X-Tidepool-Session-Token": "{$$.env.x-tidepool-session-token}",
    "Content-Type": "application/json"
  },
}
```

You can also specify start time and end time in ISO date/time format to search for data relating to a specific event (similar to [query parameters](./fetching-device-data.md#query-parameters)):

`?starttime=2015-10-10T15:00:00.000Z&endtime=2015-10-11T15:00:00.000Z`

```json http
{
  "method": "get",
  "url": "https://int-api.tidepool.org/message/notes/{$$.env.subject-userid}",
  "query": {
    "starttime": "2015-10-10T15:00:00.000Z",
    "endtime": "2015-10-11T15:00:00.000Z"
  },
  "headers": {
    "X-Tidepool-Session-Token": "{$$.env.x-tidepool-session-token}",
    "Content-Type": "application/json"
  },
}
```
