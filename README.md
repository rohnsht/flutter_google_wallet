# flutter_google_wallet

Flutter plugin for Google Wallet on Android.


### Add native add to wallet Button

```dart
GoogleWalletButton(
	style: GoogleWalletButtonStyle.button,
	height: 56,
	onPressed: () {
		// Your own handling
	},
)
```

## Existing method-channel API

You can continue using:

- `FlutterGoogleWallet().isAvailable()`
- `FlutterGoogleWallet().savePasses(passJson)`
- `FlutterGoogleWallet().savePassesJwt(passJwt)`

