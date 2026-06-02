import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_google_wallet_platform_interface.dart';

/// An implementation of [FlutterGoogleWalletPlatform] that uses method channels.
class MethodChannelFlutterGoogleWallet extends FlutterGoogleWalletPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('np.com.rohanshrestha/flutter_google_wallet');

  @override
  Future<bool?> isAvailable() async {
    return await methodChannel.invokeMethod<bool>('isAvailable');
  }

  @override
  Future<bool?> savePasses(String passJson) async {
    return await methodChannel.invokeMethod<bool>('savePasses', {"passJson": passJson});
  }

  @override
  Future<bool?> savePassesJwt(String passJwt) async {
    return await methodChannel.invokeMethod<bool>('savePassesJwt', {"passJwt": passJwt});
  }
}
