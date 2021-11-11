# Pump Settings Override (`pumpSettingsOverride`)

## Table of Contents

1. [Quick Summary](#quick-summary)
1. [Sub-Type](#subtype-subtype)
1. [Override Preset](#override-preset-overridepreset)
1. [Method](#method-method)
1. [Duration](#duration-duration)
1. [Expected Duration](#expected-duration-expectedduration)
1. [Blood Glucose Target](#blood-glucose-target-bgtarget)
1. [Basal Rate Scale Factor](#basal-rate-scale-factor-basalratescalefactor)
1. [Carbohydrate Ratio Scale Factor](#carbohydrate-ratio-scale-factor-carbratioscalefactor)
1. [Insulin Sensitivity Scale Factor](#insulin-sensitivity-scale-factor-insulinsensitivityscalefactor)
1. [Example](#example)
1. [Keep Reading](#keep-reading)

---

A pump settings override is used to temporarily override certain current pump settings for a temporary event.

The `physicalActivity` override would typically be used before, during, and/or after physical exercise to account for blood glucose level changes during exercise. For example, raising the blood glucose target for running.

The `preprandial` override would typically be used before eating and might decrease the blood glucose target range prior to eating.

The `preset` override indicates that this override can be found in the `overridePresets` of the related `pumpSettings`. In this case, the `overridePreset` field should match one of the keys in the `overridePresets` map of the related pump settings. The remainder of the fields should match those of the matching override preset.

The `sleep` override would typically be used while sleeping. This override might increase the blood glucose target range while sleeping to reduce risk of hypoglycemia overnight.

Finally the `custom` override is one that does not match any of the other override types.

---

## Quick Summary

```yaml json_schema
$ref: '../../../../reference/data/models/deviceevent/pumpsettingsoverride.v1.yaml'
```

---

## Sub-Type (`subType`)

The `pumpSettingsOverride` sub-type of device event represents a user temporarily overriding certain insulin pump settings. This might be temporarily adjusting the blood glucose target range before a meal or during exercise.

---

## Override Type (`overrideType`)

The pump settings override can be one of several types: `physicalActivity`, `preprandial`, `preset`, `sleep`, and `custom`.

---

## Override Preset (`overridePreset`)

The override matches one found in the override presets map of the related pump settings. The value of this field must match one of the keys in the `overridePresets` map in the related `pumpSettings`. The `overrideType` must be `preset`.

---

## Method (`method`)

The method indicates how the preset was enabled, if known. It can be one of `automatic` or `manual`. An `automatic` method indicates that some automated system (typically non-human) enabled the preset while a `manual` method indicates the preset was enabled manually (typically human).

--

## Duration (`duration`)

The `duration` the override is enabled for. When the override is first enabled the `duration` field can indicate how long the override is expected to be enabled for. Once the override is disabled the `duration` field should be updated to indicate the actual duration is was enable for. In this case, if the duration is less than what was expected, the `expectedDuration` field should be specified. If the override is enable indefinitely (meaning that there is no **planned** time to disable) then the `duration` field should not be specified until after the override is disabled.

---

## Expected Duration (`expectedDuration`)

Once the override is disabled, if the actual duration is less than the initial expected duration, then the `expectedDuration` field should be specified and the `duration` field updated to the actual duration.

---

## Blood Glucose Target (`bgTarget`)

The blood glucose target range in effect while the override is enabled. Not specified means no change.

---

## Basal Rate Scale Factor (`basalRateScaleFactor`)

The basal rate scale factor in effect while the override is enabled. This is a percentage of the active basal rate found in the basal rate schedule of the related `pumpSettings`. A value of 1.0 means 100% (i.e. unchanged). Not specified means no change.

---

## Carbohydrate Ratio Scale Factor (`carbRatioScaleFactor`)

The carbohydrate ratio scale factor in effect while the override is enabled. This is a percentage of the active carbohydrate ratio found in the carbohydrate ratio schedule of the related `pumpSettings`. A value of 1.0 means 100% (i.e. unchanged). Not specified means no change.

---

## Insulin Sensitivity Scale Factor (`insulinSensitivityScaleFactor`)

The insulin sensitivity scale factor in effect while the override is enabled. This is a percentage of the active insulin sensitivity found in the insulin sensitivity schedule of the related `pumpSettings`. A value of 1.0 means 100% (i.e. unchanged). Not specified means no change.

---

## Example

```json
{
  "id": "bfc3e597e16c436a94a03d7fd095a774",
  "time": "2017-02-06T02:37:46Z",
  "type": "deviceEvent",
  "subType": "pumpSettingsOverride",
  "overrideType": "preset",
  "overridePreset": "Running",
  "method": "manual",
  "duration": 2700,
  "expectedDuration": 7200,
  "bgTarget": {
    "high": 160,
    "low": 150
  },
  "basalRateScaleFactor": 0.8,
  "carbRatioScaleFactor": 1.25,
  "insulinSensitivityScaleFactor": 1.25,
  "units": {
    "bg": "mg/dL"
  },
  "uploadId": "0d92d5c1c22117a18f3620b9e24d3c06"
}
```

## Keep Reading

* [Alarm](./device-data/data-types/device-event/alarm.md)
* [Calibration](./device-data/data-types/device-event/calibration.md)
* [Common Fields](./device-data/common-fields.md)
* [Device Event](./device-data/data-types/device-event.md)
* [Prime](./device-data/data-types/device-event/prime.md)
* [Pump Settings](device-data/data-types/pump-settings)
* [Reservoir Change](./device-data/data-types/device-event/reservoir-change.md)
* [Status](./device-data/data-types/device-event/status.md)
* [Time Change](./device-data/data-types/device-event/time-change.md)
