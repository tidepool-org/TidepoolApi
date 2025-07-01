## Basal Rate (`rate`)

A floating point number >= 0 representing the amount of insulin delivered in units per hour.

Different insulin pump manufacturers offer the ability to program basal rates with different levels of precision in terms of significant digits on the rate. We endeavor to represent each rate as accurately as possible for each insulin pump; occasionally when values are stored to a falsely large number of floating point digits this means rounding the raw rate value found in a record from a pump in order to match the significant digits of precision advertised by the manufacturer. It is the burden of the uploading client to handle this rounding since the number of significant digits for rates varies according to the pump manufacturer.
