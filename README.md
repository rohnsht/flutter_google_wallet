# flutter_google_wallet

Flutter plugin for Google Wallet on Android.

## Add to Google Wallet button (Android SDK style)

The plugin exposes a native Android button widget through `GoogleWalletButton`.

1. Add the official button drawables to your Android app module:
	 - `android/app/src/main/res/drawable/add_to_google_wallet_button.xml`
	 - `android/app/src/main/res/drawable/add_to_google_wallet_button_condensed.xml`
2. Place the button in Flutter and pass either `passJson` or `passJwt`.

```dart
GoogleWalletButton(
	style: GoogleWalletButtonStyle.primary,
	height: 48,
	passJwt: signedJwt,
	onCompleted: (saved) {
		debugPrint('Saved: $saved');
	},
	onError: (code, message) {
		debugPrint('Error ($code): $message');
	},
)
```

### Manual tap handling

If you provide `onPressed`, the native button only sends tap events back to Flutter.
This is useful for fallback behavior (for example opening the web save URL when
Wallet API is unavailable).

```dart
GoogleWalletButton(
	passJwt: signedJwt,
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

