# Admin with enforced MFA

This templates creates a group in IAM named `AdminGroup`. The group will require each user to add a MFA device.

Without a MFA device the only thing that the user is allowed to do is to add a MFA device.

This also applies to any access key that the user creates. However, with a MFA device the user is allowed to assume a role that has admin rights attached.

## Enabling CLI access with the policy

Once a user has been added in the role, created an MFA tokens and added credentials in cd `~/.aws/credentials` the following profile can be added in `~/.aws/config`:

```
[profile cli]
role_arn=arn:aws:iam::<ACCOUNT_ID>:role/AdminLore
source_profile=profile-with-access-and-secret-key-in-credentials
mfa_serial=arn:aws:iam::account-without-hyphens:mfa/<USER_NAME>
```

For more information see (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html)[https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html].