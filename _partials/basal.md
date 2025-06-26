## Duration (`duration`)

An integer value representing a duration of time in milliseconds.

Note that for some insulin pumps, even for a scheduled basal not interrupted by another event like a suspend or temp, the duration may not be the nice round numbers of milliseconds that might be expected given the schedule in the pumpSettings, for example, 3600000 for a basal event lasting an hour. This is because of how some pumps schedule the small pulses of insulin delivery fulfilling the scheduled rate; depending on how the pulses are scheduled, the actual duration of the basal may be a bit over or under the scheduled duration.

This value is expected to be >= 0 and <= 432000000 (the number of milliseconds in five days), as we assume that any single basal interval, even for a user running a flat-rate basal schedule, is broken up by a suspension of delivery in order to change the infusion site and/or insulin reservoir at least every five days.


## Expected Duration (`expectedDuration`)

An integer value representing an original programmed duration of time in milliseconds, copied from the `duration` field on ingestion when a following event has resulted in truncation of the original programmed duration.

Many insulin pumps provide information on the expected duration of basals in addition to the *actual* duration of basals. (These values may differ in the case of a basal being suspended or canceled.) Where this is true, Platform will provide the same information. If you do not know what the expected duration is, do not include this information as it is an optional field.




