# Tidepool

## Introduction

Tidepool is a 501(c)(3) nonprofit organization. We were founded by people with diabetes, caregivers, and leading healthcare providers committed to helping all people with insulin-requiring diabetes safely achieve great outcomes through more accessible, actionable, and meaningful diabetes data.

We are committed to empowering the next generation of innovations in diabetes management. We harness the power of technology to provide intuitive software products that help people with diabetes.

You can learn more about Tidepool here:

* [Company](https://www.tidepool.org/about)
* [Terms of Use](https://developer.tidepool.org/terms-of-use)
* [Privacy Policy](https://developer.tidepool.org/privacy-policy)
* [Security & Architecture](https://tidepool.org/pubsec)
* [Developer Portal](https://developer.tidepool.org) (legacy, superseded by this site)

## API Documentation

We strongly believe in transparency and all of our products are open source with either [BSD-2](https://spdx.org/licenses/BSD-2-Clause.html) or [MIT](https://spdx.org/licenses/MIT.html) license. To that end, this site hosts the complete set of Tidepool APIs:

* APIs not marked `Internal`: These are APIs that are available to everyone, and are used by Tidepool's own customer-facing products.
* APIs marked `Internal`: These are APIs that are only available between services within our AWS VPC, or require privileged access level, or simply are not really useful for anyone outside of Tidepool. They are included here both for our internal reference, but also because anyone with the time and energy can see them in our open-source software.

## Environments

If you plan to develop software that uses Tidepool APIs, please send us an [email](mailto:info@tidepool.org) or join our [public #opensource Slack Channel](http://public-chat.tidepool.org). You will need to request a client identifier for your application before you can call the authentication APIs. Make sure we know who you are so that we can keep you updated on our progress and any other upcoming API changes!

### Development (`dev`, `qa1`, `qa2`)

The development environments are for Tidepool's internal development team use only. **Do not use them at all**, as they are in constant state of change and testing. There are no guarantees for privacy or stability of accounts or data.

### Integration (`int`)

The integration environment is for development proof-of-concept tests only. **Do not use it for production or PHI data**. There are no guarantees for privacy or stability of accounts or data.

To use the integration environment, you will need to create accounts on the integration environment and upload data via the integration environment. For example, before logging into the Tidepool Uploader, right click and set server to “integration”.

Once you have tested your software on the integration environment, let us know so we can review plans with you to move to our production environment.

### Production (`prd`)

Please do not use our production environment during your development. Only use the integration environment, or your own [local back-end server environment](https://github.com/tidepool-org/development).
