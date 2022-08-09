# Annotations <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

1. [Overview](#overview)
2. [Syntax And Annotation Conventions](#syntax-and-annotation-conventions)
   1. [Examples](#examples)
3. [Annotation Duplications And Storage](#annotation-duplications-and-storage)
4. [Keep Reading](#keep-reading)

---

## Overview

Tidepool strives for complete accuracy in the data uploaded to Platform. In some cases, where the data coming from diabetes devices falls just shy of the data model requirements, it is possible to implement logic that gives us high — but not 100% — confidence in the result. In such cases, Tidepool has chosen to implement this logic but also to annotate the resulting data to expose the small amount of uncertainty remaining. We have done this so we can provide the same user experience to those using various diabetes devices in their treatment.

---

## Syntax And Annotation Conventions

In the Tidepool data model, annotations is an optional property that may appear on any type in the data model, with the exception of [upload](./device-data/data-types/pump-settings/upload.md) (which is more of a metadata container). Annotations itself is an array of objects, where each object represents an individual annotation.

An annotation object must have a code property, and the typical construction of this code property is: `[manufacturer]/(datatype)/(description)`. The manufacturer prefix is optional and only present if the reason for annotation is manufacturer-specific. The data type (e.g. basal or bolus) provides another level of annotation namespacing. A descriptive and hyphen-delimited string should come last in the annotation code.

### Examples

Manufacturer/device-specific:

* `animas/bolus/extended-equal-split`
* `insulet/basal/fabricated-from-schedule`

Non-specific:

* `bg/out-of-range`

---

## Annotation Duplications And Storage

In addition to the code, an annotation object may also contain other properties. For an example of this, see the documentation on [out of range values](./oor-values.md).

Tidepoool wants to ensure there are no duplicate annotations on a single datum, so utility functions are provided in the uploader repository's `lib/eventAnnotations.js`:

* "annotate event" which checks for duplicates before adding an annotation
* "is annotated" for checking the existence of a particular annotation

While most annotations are added at the time of ingesting data into Platform, a few annotations are added during the data preprocessing in the client prior to data display. These annotations relate to event interplay across device uploads and are therefore unidentifiable during the device data ingestion process. An example of an annotation of the type is `basal/intersects-incomplete-suspend`, which we surface in Tidepool Web with a hover message of:

> "Within this basal segment, we are omitting a suspend event that didn't end. This may have resulted from changing the date & time settings on the device or switching to a new device. As a result, this basal segment may be inaccurate."
>

The best resource for viewing all current annotations in the Tidepool data model is the [tideline code](https://github.com/tidepool-org/tideline/blob/master/js/plot/util/annotations/annotationdefinitions.js) where the user-facing messages are defined for each annotation code.

---

## Keep Reading

* [Diabetes Data Types](./data-types.md)
* [Out Of Range Values](./oor-values.md)
* [Pump Settings](./data-types/pump-settings.md)
