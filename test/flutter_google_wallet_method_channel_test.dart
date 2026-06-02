import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_google_wallet/flutter_google_wallet_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterGoogleWallet platform = MethodChannelFlutterGoogleWallet();
  const MethodChannel channel = MethodChannel('np.com.rohanshrestha/flutter_google_wallet');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '42';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('isAvailable returns true when native method returns true', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'isAvailable') {
            return true;
          }
          return null;
        });

    final result = await platform.isAvailable();
    expect(result, true);
  });

  test('isAvailable returns false when native method returns false', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'isAvailable') {
            return false;
          }
          return null;
        });

    final result = await platform.isAvailable();
    expect(result, false);
  });

  test('savePasses sends passJson and returns true', () async {
    const String testPassJson = '{"test": "data"}';
    
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'savePasses') {
            final args = methodCall.arguments as Map<dynamic, dynamic>;
            expect(args['passJson'], testPassJson);
            return true;
          }
          return null;
        });

    final result = await platform.savePasses(testPassJson);
    expect(result, true);
  });

  test('savePasses sends correct arguments to native', () async {
    const String testPassJson = '{"type": "GENERIC", "id": "test123"}';
    final capturedArgs = <dynamic, dynamic>{};

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'savePasses') {
            capturedArgs.addAll(methodCall.arguments as Map<dynamic, dynamic>);
            return true;
          }
          return null;
        });

    await platform.savePasses(testPassJson);
    expect(capturedArgs['passJson'], testPassJson);
  });

  test('savePassesJwt sends passJwt and returns true', () async {
    const String testJwt = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.test.test';
    
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'savePassesJwt') {
            final args = methodCall.arguments as Map<dynamic, dynamic>;
            expect(args['passJwt'], testJwt);
            return true;
          }
          return null;
        });

    final result = await platform.savePassesJwt(testJwt);
    expect(result, true);
  });

  test('savePassesJwt sends correct JWT token to native', () async {
    const String testJwt = 'eyJhbGciOiJSUzI1NiJ9.eyJ0eXAiOiJXYWxsZXQifQ.test';
    final capturedArgs = <dynamic, dynamic>{};

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'savePassesJwt') {
            capturedArgs.addAll(methodCall.arguments as Map<dynamic, dynamic>);
            return true;
          }
          return null;
        });

    await platform.savePassesJwt(testJwt);
    expect(capturedArgs['passJwt'], testJwt);
  });

  test('method channel has correct name', () {
    expect(platform.methodChannel.name, 'np.com.rohanshrestha/flutter_google_wallet');
  });

  test('isAvailable handles null return', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return null;
        });

    final result = await platform.isAvailable();
    expect(result, null);
  });

  test('savePasses handles failure return', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'savePasses') {
            return false;
          }
          return null;
        });

    final result = await platform.savePasses('{}');
    expect(result, false);
  });

  test('savePassesJwt handles failure return', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'savePassesJwt') {
            return false;
          }
          return null;
        });

    final result = await platform.savePassesJwt('token');
    expect(result, false);
  });
}
