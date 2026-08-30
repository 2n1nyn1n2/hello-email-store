# configure secrets

[Go to your Repository Secrets](../../settings/secrets/actions)

configure these secrets:

| KEY                                | VALUE                                                    |
| ---------------------------------- |--------------------------------------------------------- |
| APP_STORE_CONNECT_API_KEY_ID	     | The 10-character key ID generated in App Store Connect.  |
| APP_STORE_CONNECT_API_ISSUER_ID    | The Issuer ID (UUID) from App Store Connect.             |
| APP_STORE_CONNECT_API_KEY_BASE64   | The raw .p8 key file contents converted to Base64.       |
| APPLE_DEVELOPER_TEAM_ID	         | Your 10-character Apple Team ID.                         |
| ---------------------------------- |--------------------------------------------------------- |

# make a build

	git tag v1.0.0;
	git push origin v1.0.0;

note on publishing this example to a different github repo

[Go to your Repository Github Notes](github-notes.md)