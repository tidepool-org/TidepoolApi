# Authentication

## Introduction

Tidepool uses standard [OpenID Connect](https://openid.net/) or [OAuth2](https://tools.ietf.org/html/rfc6749) for authentication and authorization flows. This provides a mechanism for 3rd party developers to securely request Tidepool to authenticate a user while ensuring privacy and confidentiality of that user's login credentials.

We also support external identity providers (IdP) for clinics that wish to utilize their own single sign-on (SSO) solution. Please contact [Tidepool Sales Team](mailto:sales@tidepool.org) to enable SSO for your clinic. Clinicians who log in to Tidepool are directed to their clinic's SSO login page that may be hosted by services such as [Okta](https://www.okta.com/), [Auth0](https://auth0.com/), [Microsoft ADFS](https://learn.microsoft.com/en-us/windows-server/identity/active-directory-federation-services), and so on. Upon successful login, the clinician user will be redirected back to Tidepool Web.

The following references provide more detailed information on the principles and implementation of OAuth 2.0:

* [How OpenID Connect Works](https://openid.net/developers/how-connect-works/)
* [OAuth - RFC 7649](https://tools.ietf.org/html/rfc6749)
* [An Introduction to OAuth 2](https://www.digitalocean.com/community/tutorials/an-introduction-to-oauth-2)
* [OAuth 2 Simplified](https://aaronparecki.com/2012/07/29/2/oauth2-simplified)
* [OAuth 2.0 Servers](https://www.oauth.com/)

## Access Tokens and Refresh Tokens

Tidepool access tokens are relatively short-lived (as in, minutes). Once expired, they must be refreshed using the refresh token returned by Tidepool's authentication service.

## Two-Factor Authentication (2FA)

In the future, Tidepool will be offering the option for users to enable 2-factor authentication (2FA) to their account to further secure their account. In order to login, the user will have to present their email and password as well as a 6-digit number generated by the 2FA provider such as 1Password or Google Authenticator.
