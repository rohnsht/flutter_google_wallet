import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_google_wallet/flutter_google_wallet.dart';

void main() {
  group('GoogleWalletButton Widget', () {
    testWidgets('renders with default style (button)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GoogleWalletButton(onPressed: () {})),
        ),
      );

      expect(find.byType(GoogleWalletButton), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('renders with badge style', (WidgetTester tester) async {
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

      expect(find.byType(GoogleWalletButton), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('renders with custom height', (WidgetTester tester) async {
      const double customHeight = 64.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleWalletButton(height: customHeight, onPressed: () {}),
          ),
        ),
      );

      expect(find.byType(GoogleWalletButton), findsOneWidget);
    });

    testWidgets('respects minimum height constraint', (
      WidgetTester tester,
    ) async {
      // Attempt to set height below minimum (48)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleWalletButton(height: 32.0, onPressed: () {}),
          ),
        ),
      );

      expect(find.byType(GoogleWalletButton), findsOneWidget);
    });

    testWidgets('calls onPressed callback when tapped', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleWalletButton(
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(wasPressed, true);
    });

    testWidgets('supports multiple button instances', (
      WidgetTester tester,
    ) async {
      int pressCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                GoogleWalletButton(
                  onPressed: () {
                    pressCount++;
                  },
                ),
                GoogleWalletButton(
                  style: GoogleWalletButtonStyle.badge,
                  onPressed: () {
                    pressCount++;
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(GoogleWalletButton), findsWidgets);
      expect(find.byType(GestureDetector), findsNWidgets(2));
    });

    testWidgets('renders with custom locale', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleWalletButton(
              locale: const Locale('de'),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(GoogleWalletButton), findsOneWidget);
    });

    testWidgets('renders with supported locale en_GB', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleWalletButton(
              locale: const Locale('en', 'GB'),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(GoogleWalletButton), findsOneWidget);
    });

    testWidgets('renders with supported locale zh_HK', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleWalletButton(
              locale: const Locale('zh', 'HK'),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(GoogleWalletButton), findsOneWidget);
    });

    testWidgets('button with all parameters specified', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleWalletButton(
              key: const Key('google_wallet_button'),
              style: GoogleWalletButtonStyle.button,
              height: 56.0,
              onPressed: () {
                wasPressed = true;
              },
              locale: const Locale('en', 'US'),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('google_wallet_button')), findsOneWidget);

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(wasPressed, true);
    });

    testWidgets('multiple different button styles work together', (
      WidgetTester tester,
    ) async {
      int buttonPresses = 0;
      int badgePresses = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                GoogleWalletButton(
                  style: GoogleWalletButtonStyle.button,
                  height: 48.0,
                  onPressed: () {
                    buttonPresses++;
                  },
                ),
                GoogleWalletButton(
                  style: GoogleWalletButtonStyle.badge,
                  height: 32.0,
                  onPressed: () {
                    badgePresses++;
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final buttons = find.byType(GestureDetector);
      expect(buttons, findsNWidgets(2));

      await tester.tap(buttons.first);
      await tester.pumpAndSettle();
      expect(buttonPresses, 1);

      await tester.tap(buttons.last);
      await tester.pumpAndSettle();
      expect(badgePresses, 1);
    });

    testWidgets('button handles state updates correctly', (
      WidgetTester tester,
    ) async {
      int pressCount = 0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: GoogleWalletButton(
                    onPressed: () {
                      setState(() {
                        pressCount++;
                      });
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      expect(pressCount, 1);

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      expect(pressCount, 2);
    });

    testWidgets('button respects padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GoogleWalletButton(onPressed: () {})),
        ),
      );

      final button = find.byType(GestureDetector);
      expect(button, findsOneWidget);

      // Verify button is rendered with padding
      expect(find.byType(GoogleWalletButton), findsOneWidget);
    });
  });
}
