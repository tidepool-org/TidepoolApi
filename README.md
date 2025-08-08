# TidepoolApi 

![Tidepool Logo](./assets/images/Tidepool_Logo_Dark_Large.png)

[![publish](https://github.com/tidepool-org/TidepoolApi/actions/workflows/check-and-publish.yml/badge.svg?branch=master)](https://github.com/tidepool-org/TidepoolApi/actions/workflows/check-and-publish.yml)

This repository contains Tidepool Platform API documentation in [OpenAPI v3](https://www.openapis.org/) format with additional narrative content in [Markdoc](https://redocly.com/learn/markdoc/write-with-markdoc) format which in turn extends on [Markdown](https://www.markdownguide.org/).
These API definitions can be used to generate stub code for either server or client side. Currently, we only do this with the `clinic` service (see below for special note on that).

## Workflow

We have an account in [Redocly](https://tidepool.redocly.app) for publishing the documentation and API specifications. The goal is for that site to soon replace the current [developer portal](https://developer.tidepool.org). It *is* possible to edit the documentation files directly online in Redocly - however we are *not* using that capability, for several reasons:

1. Doing so requires using one of a limited number of seats (5).
2. It does not fit well into our normal review/approval workflow.
3. It does not enable us to run pre-merge checks, in particular to validate changes that could break generated server stub code such as the [`clinic`](https://github.com/tidepool-org/clinic) service. See the `check` and `generate` steps in the [Makefile](./Makefile).

The preferred workflow is to edit these files offline, then commit them to GitHub which automatically pushes updates into Redocly, including work branches though they are not visible to people outside of Tidepool. Here are the workflow details:

1. Clone this repository and install the validation & publishing tools. You only need to to this once.

    ```shell
    git clone https://github.com/tidepool-org/TidepoolApi.git
    cd TidepoolApi
    make install_tools
    ```

2. Create a *work branch* for your edits:

    ```shell
    git checkout master
    git pull
    git checkout master -b {branch}
    ```

3. Edit and preview the files offline using any of the [tools](#editing-tools) listed below.
4. Validate your changes locally:

    ```shell
    make check
    make prepare
    ```

5. Commit your changes to the work branch and push to GitHub. This will automatically kick off a [GitHub Action](.github/workflows/) that checks & publishes the new (draft) documentation into a branch in Redocly.

    ```shell
    git add {file(s)}
    git commit -m "{description}"
    git checkout master
    git pull
    git checkout {branch}
    git merge --no-ff master
    git push -u origin HEAD
    ```

6. Post a pull request (PR) to review the changes
7. Once the PR is approved, merge to master which will again automatically update the master branch in the Redocly site.

## Editing Tools

1. Free [Stoplight Studio](https://stoplight.io/studio/) for validating and rendering OpenAPI v3 specifications.
2. Free Microsoft [Visual Studio Code](https://code.visualstudio.com/), with plug-ins for validating and rendering OpenAPI v3 specifications and Markdown documentation.
3. Many other IDEs offer similar plug-ins.

## Other Tools

The [Makefile](./Makefile) makes use of several CLI tools to check, prepare, and publish the documentation and specifications.
You can install the tools by executing the following command:

```shell
make install_tools
```

You can check if you have all the tools installed by executing the following command:

```shell
make check_tools
```

| Tool | Description |
|------|-------------|
| [markdownlint](https://www.npmjs.com/package/markdownlint) | Validates Markdown files. |
| [markdown-link-check](https://www.npmjs.com/package/markdown-link-check) | Validates hyperlinks in Markdown files. |
| [spectral](https://www.npmjs.com/package/@stoplight/spectral) | Validates OpenAPI 3.0 specification files. |
| [swagger-cli](https://www.npmjs.com/package/swagger-cli) | Validates OpenAPI 3.0 specification files. Also bundles multiple OAS3 files into a single file, that is required by some downstream use-cases. |
| [redocly](https://github.com/Redocly/redocly-cli) | Validates OpenAPI 3.0 specification files. Also bundles multiple OAS3 files into a single file, that is required by some downstream use-cases. |
| [openapi-merge-cli](https://www.npmjs.com/package/openapi-merge-cli) | Merges OpenAPI 3.0 specification files into single file. |
| [oapi-codegen](https://github.com/deepmap/oapi-codegen) | Generates server and client stub code from OpenAPI 3.0 specifications. Used currently to generate the [`clinic`](https://github.com/tidepool-org/clinic) service code. |
