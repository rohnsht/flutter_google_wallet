import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_google_wallet/flutter_google_wallet.dart';
import 'package:flutter_google_wallet/flutter_google_wallet_platform_interface.dart';

/// Mock implementation of FlutterGoogleWalletPlatform for testing
class MockFlutterGoogleWalletPlatform extends FlutterGoogleWalletPlatform {
  bool? _isAvailableReturnValue = true;
  bool? _savePassesReturnValue = true;
  bool? _savePassesJwtReturnValue = true;
  String? _lastPassJson;
  String? _lastPassJwt;
  int isAvailableCallCount = 0;
  int savePassesCallCount = 0;
  int savePassesJwtCallCount = 0;

  @override
  Future<bool?> isAvailable() async {
    isAvailableCallCount++;
    return _isAvailableReturnValue;
  }

  @override
  Future<bool?> savePasses(String passJson) async {
    savePassesCallCount++;
    _lastPassJson = passJson;
    return _savePassesReturnValue;
  }

  @override
  Future<bool?> savePassesJwt(String passJwt) async {
    savePassesJwtCallCount++;
    _lastPassJwt = passJwt;
    return _savePassesJwtReturnValue;
  }
}

void main() {
  late MockFlutterGoogleWalletPlatform mockPlatform;
  late FlutterGoogleWallet flutterGoogleWallet;

  setUp(() {
    mockPlatform = MockFlutterGoogleWalletPlatform();
    FlutterGoogleWalletPlatform.instance = mockPlatform;
    flutterGoogleWallet = FlutterGoogleWallet();
  });

  group('FlutterGoogleWallet', () {
    test('isAvailable calls platform isAvailable', () async {
      mockPlatform._isAvailableReturnValue = true;

      final result = await flutterGoogleWallet.isAvailable();

      expect(result, true);
      expect(mockPlatform.isAvailableCallCount, 1);
    });

    test('isAvailable returns false when platform returns false', () async {
      mockPlatform._isAvailableReturnValue = false;

      final result = await flutterGoogleWallet.isAvailable();

      expect(result, false);
    });

    test('isAvailable returns null when platform returns null', () async {
      mockPlatform._isAvailableReturnValue = null;

      final result = await flutterGoogleWallet.isAvailable();

      expect(result, null);
    });

    test('savePasses calls platform with correct passJson', () async {
      const String testPassJson = '{"test": "data"}';
      mockPlatform._savePassesReturnValue = true;

      final result = await flutterGoogleWallet.savePasses(testPassJson);

      expect(result, true);
      expect(mockPlatform.savePassesCallCount, 1);
      expect(mockPlatform._lastPassJson, testPassJson);
    });

    test('savePasses returns true on success', () async {
      const String passJson = '{"type": "GENERIC"}';
      mockPlatform._savePassesReturnValue = true;

      final result = await flutterGoogleWallet.savePasses(passJson);

      expect(result, true);
    });

    test('savePasses returns false on failure', () async {
      const String passJson = '{"type": "GENERIC"}';
      mockPlatform._savePassesReturnValue = false;

      final result = await flutterGoogleWallet.savePasses(passJson);

      expect(result, false);
    });

    test('savePasses with complex JSON object', () async {
      const String complexPassJson = '''
      {
        "type": "GENERIC",
        "id": "test123",
        "classId": "class123",
        "genericObjects": [
          {
            "id": "obj1",
            "name": "Test Pass"
          }
        ]
      }
      ''';
      mockPlatform._savePassesReturnValue = true;

      final result = await flutterGoogleWallet.savePasses(complexPassJson);

      expect(result, true);
      expect(mockPlatform._lastPassJson, complexPassJson);
    });

    test('savePassesJwt calls platform with correct JWT', () async {
      const String testJwt = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.test.test';
      mockPlatform._savePassesJwtReturnValue = true;

      final result = await flutterGoogleWallet.savePassesJwt(testJwt);

      expect(result, true);
      expect(mockPlatform.savePassesJwtCallCount, 1);
      expect(mockPlatform._lastPassJwt, testJwt);
    });

    test('savePassesJwt returns true on success', () async {
      const String jwt = 'valid.jwt.token';
      mockPlatform._savePassesJwtReturnValue = true;

      final result = await flutterGoogleWallet.savePassesJwt(jwt);

      expect(result, true);
    });

    test('savePassesJwt returns false on failure', () async {
      const String jwt = 'invalid.jwt.token';
      mockPlatform._savePassesJwtReturnValue = false;

      final result = await flutterGoogleWallet.savePassesJwt(jwt);

      expect(result, false);
    });

    test('savePassesJwt with long JWT token', () async {
      const String longJwt =
          'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhdWQiOiJodHRwczovL3RvdWdhcHBzLmdvb2dsZS5jb20vIiwib3V0ZXIiOlt7ImNsYXNzSWQiOiJxMDgxNjIzNzQ1OTg3NjU0MzIxIn1dLCJzdWIiOiI2MTg5OTM5NzcwODc5ODAwODMyIn0.test';
      mockPlatform._savePassesJwtReturnValue = true;

      final result = await flutterGoogleWallet.savePassesJwt(longJwt);

      expect(result, true);
      expect(mockPlatform._lastPassJwt, longJwt);
    });

    test('multiple calls to isAvailable increment call count', () async {
      mockPlatform._isAvailableReturnValue = true;

      await flutterGoogleWallet.isAvailable();
      await flutterGoogleWallet.isAvailable();
      await flutterGoogleWallet.isAvailable();

      expect(mockPlatform.isAvailableCallCount, 3);
    });

    test('multiple calls to savePasses track all arguments', () async {
      mockPlatform._savePassesReturnValue = true;
      const String pass1 = '{"id": "1"}';
      const String pass2 = '{"id": "2"}';

      await flutterGoogleWallet.savePasses(pass1);
      await flutterGoogleWallet.savePasses(pass2);

      expect(mockPlatform.savePassesCallCount, 2);
      expect(mockPlatform._lastPassJson, pass2);
    });
  });

  group('GoogleWalletButtonStyle', () {
    test('button style returns wallet_button value', () {
      expect(GoogleWalletButtonStyle.button.value, 'wallet_button');
    });

    test('badge style returns add_wallet_badge value', () {
      expect(GoogleWalletButtonStyle.badge.value, 'add_wallet_badge');
    });

    test('all styles have correct values', () {
      final styles = GoogleWalletButtonStyle.values;
      expect(styles.length, 2);
      expect(styles.map((s) => s.value).toSet().length, 2);
    });

    test('button style value is correct string', () {
      const style = GoogleWalletButtonStyle.button;
      expect(style.value, equals('wallet_button'));
    });

    test('badge style value is correct string', () {
      const style = GoogleWalletButtonStyle.badge;
      expect(style.value, equals('add_wallet_badge'));
    });
  });
}
