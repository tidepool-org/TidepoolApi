# Units

Platform does not mutate data. Rather, data is read from diabetes devices and stored in near original form while still translating into the standardized Tidepool data model.

An exception is made, however, for blood glucose data. Tidepool has chosen to store blood glucose data in `mmol/L` units only. Tidepool chose mmol/L because it is the standard for international research and because, as a floating point number, it can be converted accurately to `mg/dL`, which is typically an integer.

Event types that include a blood glucose value or blood glucose-related value (such as an insulin sensitivity factor) must also have a units field specified – either mg/dL or mmol/L. When that field is **mg/dL**, upon its ingestion through Platform, the value is converted to **mmol/L**, the units field updated accordingly and the event is stored.

The algorithm followed for conversion of blood glucose/related values from mg/dL to mmol/L is:

1. If units field is **mg/dL** divide the value by 18.01559 (the molar mass of glucose is 180.1559)
2. Store the resulting floating point precision value without rounding or truncation
3. The value has now been converted into **mmol/L**
