# README for `tools`

These are internal tools that were developed to help manage the [OpenAPI v3](https://www.openapis.org/) specifications.
These require [Ruby](https://www.ruby-lang.org/en/) language, version 2.6 or later.

## [`build_toc.rb`](build_toc.rb)
This tool reads the `.stoplight.json` configuration file, and then finds all documentation files (Markdown) and OpenAPI 3 specification files (YAML) and renders a new hierarchical table of contents file `toc.json` from them.
This is what it uses for the item titles:

* Markdown documents: the top-level header tag `# `.
* OpenAPI v3 endpoint spec: the `title` tag inside the `info` section, minus any `API` or `Service` suffix.
* OpenAPI v3 model spec: the `title` tag.

The `toc.json` file is used by [Stoplight Studio](https://stoplight.io/studio/) and [Stoplight Platform](https://stoplight.io/) to render sidebar navigation.
Stoplight Studio also has a built-in feature that can generate the `toc.json` file, but the TOC it produces is frankly pretty ugly.

The overall structure of the generated TOC is as follows:

> GUIDES
> * Markdown 1
> * Markdown 2
>   * Overview
>   * Markdown 2.1
>   * Markdown 2.2
> * Markdown 3
>
> APIs
>   * `API 1`
>     * Overview
>     * Operations
>       * `Operation 1`
>       * `Operation 2`
>       * `Operation 3`
>     * Models
>       * `Model 1`
>       * `Model 2`
>   * `API 2`
>     * Overview
>     * ...

NOTE: each section of the generated TOC is sorted alphabetically by title.
For the most part, this makes sense.
However, the TOC will require minor hand-editing to move some content such as the _Welcome!_ and _Getting Started_ articles to the top of the TOC.

## [`combine.rb`](combine.rb)
This tool reads individual OpenAPI 3 specification YAML files from the `reference` folder and merge them into one single OpenAPI v3 YAML file.
It uses a rudimentary fill-in-the-blanks template file `templates/combined.v1.yaml` for the layout.

## [`convert_hub_yaml_to_md.rb`](convert_hub_yaml_to_md.rb)
This was a one-off tool for migrating the Markdown content from the legacy Stoplight Next service to Stoplight Studio, the new desktop editing tool for OpenAPI v3 specifications. Stoplight Next stored Markdown content embedded inside a single file called `main.hub.yml`. This script splits that single file apart into separate YAML files in a folder hierarchy. It has no real use beyond that initial migration, so it is included here only for posterity.
