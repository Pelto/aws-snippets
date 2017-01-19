# Instructions

## Applying the policy for the AWS Console

To set up the policy and require everyone to use an MFA device for signing into
the console do the following:

1. Open `iam-admin-mfa-policy.json` and replace `account-id-without-hyphens` with your account number.
2. Create the policy and attach it to the groups that you it applies to.

With this in place all users in the group will now have to add an MFA device to
their account before being able to do anything else.

Note that when the MFA device has been added the user have to sign out and sign
in as the policy requires the user's session to be authenticated with the
policy.

## Enabling CLI access with the policy

To be able to access the AWS services through the CLI with this policy use the
following steps:

Create a role with admin privilieges that can be assumed and require MFA
for assuming the role.

For accessing the role, have each user add generate a secret access key and
store them in a seperate profile in `~/.aws/credentials`. Then modify
`~/.aws/config` and add the following:

```
[profile cli]
role_arn=arn:aws:iam::account-without-hyphens:role/role
source_profile=profile-with-access-and-secret-key
mfa_serial=arn:aws:iam::account-without-hyphens:mfa/user
```
