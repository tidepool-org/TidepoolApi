# Diabetes Data Types

This documents the diabetes device data types that Platform reads and stores. All events read and stored by Platform use the JSON data interchange format and have a type field identifying the subcategory of event. The semantics of the other fields in each subcategory are generally defined individually per subcategory, but there are some [common fields](./common-fields.md).

## Diabetes Data Types

* [Basal Insulin](./data-types/basal.md)
* [Blood Ketones](./data-types/blood-ketones.md)
* [Bolus Insulin](./data-types/bolus.md)
* [Continuous Blood Glucose (CBG)](./data-types/cbg.md) 
* [CGM Settings](./data-types/cgm-settings.md)
* [Device Event (Miscellaneous)](./data-types/device-event.md)
* [Pump Settings](./data-types/pump-settings.md)
* [Self-Monitored Blood Glucose (SMBG)](./data-types/pump-settings/smbg.md)
* [Upload Metadata](./data-types/pump-settings/upload.md)
* [Bolus Calculator (wizard)](./data-types/pump-settings/calculator.md)

<!-- theme: info -->

> Go to the [diabetes device data model](../device-data.md) for additional information not listed here.
