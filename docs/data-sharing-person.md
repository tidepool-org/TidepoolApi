<!-- omit in toc -->
# Tidepool User Shares Their Data with a Person

## Introduction

Alice (person with diabetes) wants to share *her* diabetes data with Bob. Bob could be anyone she trusts: spouse, parent, family member or a clinician. She can revoke that access permission at any time, and there is no limit to the number of sharing relationships.

If Bob does not yet have a Tidepool account, he will have to create one before he can accept the invitation from Alice. Bob can only access Alice's data while he is successfully authenticated to Tidepool.

## Flow

```mermaid
sequenceDiagram
    autonumber
    actor PWD as Alice
    participant Web as Tidepool Web
    link Web: https://app.tidepool.org @ https://app.tidepool.org
    participant Platform as Tidepool Platform
    link Platform: https://api.tidepool.org @ https://api.tidepool.org
    participant Database as MongoDB Atlas
    actor Careteam as Bob

    Careteam->>PWD: Provide email address
    activate PWD
    note over PWD: Alice invites Bob
    PWD->>Web: Enter email address
    activate Web
    Web->>Platform: Send invitation
    activate Platform
    Platform->>Database: Create invitation
    Platform->>Careteam: Send invitation email to Bob
    Platform->>Web: OK
    deactivate Platform
    Web->>PWD: OK
    deactivate Web
    deactivate PWD

    note over Careteam: Bob accepts the pending invitation
    Careteam->>Web: Click on link in invitation email
    activate Web
    Web->>Platform: Update invitation
    activate Platform
    Platform->>Database: Update invitation
    Platform->>Database: Create permission
    Platform->>Web: OK
    deactivate Platform
    Web->>Careteam: OK
    deactivate Web
    note over Careteam: Bob can now access Alice's data

    note over PWD: Alice revokes Bob's access
    PWD->>Web: Revoke Bob's access
    activate Web
    Web->>Platform: Delete permission
    activate Platform
    Platform->>Database: Delete permission
    note over Careteam: Bob can no longer access Alice's data
    Platform->>Web: OK
    deactivate Platform
    Web->>PWD: OK
    deactivate Web
```
