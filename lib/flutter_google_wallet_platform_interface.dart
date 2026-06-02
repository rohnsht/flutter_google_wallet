import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_google_wallet_method_channel.dart';

abstract class FlutterGoogleWalletPlatform extends PlatformInterface {
  /// Constructs a FlutterGoogleWalletPlatform.
  FlutterGoogleWalletPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterGoogleWalletPlatform _instance = MethodChannelFlutterGoogleWallet();

  /// The default instance of [FlutterGoogleWalletPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterGoogleWallet].
  static FlutterGoogleWalletPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterGoogleWalletPlatform] when
  /// they register themselves.
  static set instance(FlutterGoogleWalletPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> isAvailable() {
    throw UnimplementedError('isAvailable() has not been implemented.');
  }

  Future<bool?> savePasses(String passJson) {
    throw UnimplementedError('savePasses() has not been implemented.');
  }

  Future<bool?> savePassesJwt(String passJwt) {
    throw UnimplementedError('savePassesJwt() has not been implemented.');
  }
}
