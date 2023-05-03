<!-- omit in toc -->
# Tidepool User Shares Their Data with a Clinic

## Introduction

Sharing data with a clinic works for the most part exactly like sharing data with a person. However, instead of using an email address, the sharing relationship is initiated with a *share code*: a randomly generated sequence of 12 alphanumeric letters from the set `ABCDEFGHJKLMNPQRSTUVWXYZ23456789`, in 3 groups separated by dashes like `XXXX-YYYY-ZZZZ`. Note that the letters `I` and `O`, and the digits `0` and `1` are excluded to reduce ambiguity.

The other difference is that sharing data with a clinic grants access to all members of that clinic, rather than individual clinicians.

## Flow

```mermaid
sequenceDiagram
    autonumber
    actor PWD as Alice
    participant Web as Tidepool Web
    link Web: https://app.tidepool.org @ https://app.tidepool.org
    participant Platform as Tidepool Platform
    link Platform: https://api.tidepool.org @ https://api.tidepool.org
    actor Clinic as Seastar Endocrinology

    Clinic->>PWD: Provide share code
    activate PWD
    note over PWD: Alice creates invitation
    PWD->>Web: Enter share code
    activate Web
    Web->>Platform: Send invitation
    activate Platform
    Platform->>Platform: Create invitation
    Platform->>Clinic: Send invitation email to clinic staff
    note over Clinic: Pending invitations also appear in TP Web
    Platform->>Web: OK
    deactivate Platform
    Web->>PWD: OK
    deactivate Web
    deactivate PWD

    note over Clinic: Clinician accepts the invitation
    alt via Web
      Clinic->>Web: Click on pending invitation in patient list
      activate Web
    else via Email
      Clinic->>Web: Click on link in invitation email
    end
    Web->>Platform: Update invitation
    activate Platform
    Platform->>Platform: Update invitation
    Platform->>Platform: Create permission
    Platform->>Web: OK
    deactivate Platform
    Web->>Clinic: OK
    deactivate Web
    note over Clinic: Clinicians can now access Alice's data

    note over PWD: Alice revokes clinic's access
    PWD->>Web: Revoke clinic's access
    activate Web
    Web->>Platform: Delete permission
    activate Platform
    Platform->>Platform: Delete permission
    note over Clinic: Clinicians can no longer access Alice's data
    Platform->>Web: OK
    deactivate Platform
    Web->>PWD: OK
    deactivate Web
```
