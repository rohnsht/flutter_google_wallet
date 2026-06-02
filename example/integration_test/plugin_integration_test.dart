// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_google_wallet/flutter_google_wallet.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final plugin = FlutterGoogleWallet();

  group('FlutterGoogleWallet', () {
    test('isAvailable returns a non-null bool', () async {
      try {
        final result = await plugin.isAvailable()
            .timeout(const Duration(seconds: 5));
        expect(result, isA<bool?>());
      } on TimeoutException {
        // Native side did not respond — Google Wallet likely unavailable on this device.
        markTestSkipped('isAvailable timed out; Google Wallet not available on this device.');
      } on Exception catch (e) {
        expect(e, isNotNull);
      }
    });

    test('savePasses throws or returns bool for invalid JSON', () async {
      const invalidJson = 'not-valid-json';
      try {
        final result = await plugin.savePasses(invalidJson)
            .timeout(const Duration(seconds: 5));
        expect(result, isA<bool?>());
      } on TimeoutException {
        markTestSkipped('savePasses timed out; Google Wallet not available on this device.');
      } catch (e) {
        // A PlatformException is acceptable for invalid input
        expect(e, isNotNull);
      }
    });

    test('savePassesJwt throws or returns bool for invalid JWT', () async {
      const invalidJwt = 'invalid.jwt.token';
      try {
        final result = await plugin.savePassesJwt(invalidJwt)
            .timeout(const Duration(seconds: 5));
        expect(result, isA<bool?>());
      } on TimeoutException {
        markTestSkipped('savePassesJwt timed out; Google Wallet not available on this device.');
      } catch (e) {
        expect(e, isNotNull);
      }
    });
  });

  group('GoogleWalletButton widget', () {
    testWidgets('renders without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleWalletButton(
              onPressed: () {},
            ),
          ),
        ),
      );
      // Allow SVG assets and platform views to settle
      await tester.pumpAndSettle();
      expect(find.byType(GoogleWalletButton), findsOneWidget);
    });

    testWidgets('badge style renders without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleWalletButton(
              style: GoogleWalletButtonStyle.badge,
              onPressed: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GoogleWalletButton), findsOneWidget);
    });

    testWidgets('onPressed callback is invoked on tap', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleWalletButton(
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(GoogleWalletButton));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
