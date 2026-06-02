import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_google_wallet/flutter_google_wallet_platform_interface.dart';
import 'package:flutter_google_wallet/flutter_google_wallet_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterGoogleWalletPlatform
    with MockPlatformInterfaceMixin
    implements FlutterGoogleWalletPlatform {
  
  @override
  Future<bool?> isAvailable() {
    throw UnimplementedError();
  }
  
  @override
  Future<bool?> savePasses(String passJson) {
    throw UnimplementedError();
  }
  
  @override
  Future<bool?> savePassesJwt(String passJwt) {
    throw UnimplementedError();
  }
}

void main() {
  final FlutterGoogleWalletPlatform initialPlatform = FlutterGoogleWalletPlatform.instance;

  test('$MethodChannelFlutterGoogleWallet is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterGoogleWallet>());
  });
}
