# Insulin (`insulin`)

An insulin delivery event that is not associated with a basal or bolus, usually logged as a contextual event on a CGM receiver or BG meter.

## Dose (`dose`)

The actual dose of insulin, consisting of:

- `total` - total insulin dose delivered (independent of `correction` + `food` - `active`)
- `active` - active insulin, i.e., insulin on board
- `correction` - insulin to bring the person with diabetes to their target BG
- `food` - insulin to "cover" food input
- `units` - units for dose, currently only `Units` are used

## Formulation (`formulation`)

A formulation consist of a name (e.g. "My custom mix") and either an array of `compounds` objects with amounts, or a `simple` formulation:

- `actingType` - can be rapid, short, intermediate or long
- `brand` - optional text field with the brand, e.g. "Humalog"
- `concentration` - value in units/mL

## Site (`site`)

There is an optional `site` text field (0-100 characters) to describe where injection was taken.

## Quick Summary

{% json-schema
  schema={
    "$ref": "../../../reference/data/models/insulin/insulin.v1.yaml"
  }
/%}

## Examples

```json {% title="Example (insulin)" %}
{
    "type": "insulin",
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
    "dose": {
      "units": "Units",
      "total": 250,
      "food": 250,
      "correction": -250,
      "active": 250
    },
    "formulation": {
      "compounds": [
        {
          "amount": 0.1
        }
      ],
      "name": "string"
    },
    "site": "string"
}
```