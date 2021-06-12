# Diabetes Data Types

This documents the diabetes device data types that Platform reads and stores. All events read and stored by Platform use the JSON data interchange format and have a type field identifying the subcategory of event. The semantics of the other fields in each subcategory are generally defined individually per subcategory, but there are some [common fields](./common-fields.md).

## Diabetes data types:

* [Basal insulin](./data-types/basal.md)
* [Blood ketones](./data-types/blood-ketones.md)
* [Bolus insulin](./data-types/bolus.md)
* [Continuous blood glucose (CBG)](./data-types/cbg.md) 
* [CGM settings](./data-types/cgm-settings.md)
* [Device event (miscellaneous)](./data-types/device-event.md)
* [Pump settings](./data-types/pump-settings.md)
* [Self-monitored blood glucose (SMBG)](./data-types/pump-settings/smbg.md)
* [Upload metadata](./data-types/pump-settings/upload.md)
* [Bolus calculator (wizard)](./data-types/pump-settings/calculator.md)

<!-- theme: info -->

> Go to the [diabetes device data model](../device-data.md) for additional information not listed here.

