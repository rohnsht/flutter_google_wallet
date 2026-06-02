import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_google_wallet/flutter_google_wallet.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Wallet Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Google Wallet Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final googleWallet = FlutterGoogleWallet();
  final String jwt =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJ3YWxsZXQtcGFzcy1jcmVhdG9yQGFyY2hlZC13aGFyZi05NTEwNC5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImF1ZCI6Imdvb2dsZSIsInR5cCI6InNhdmV0b3dhbGxldCIsImlhdCI6MTc4MDM2NDQ3NywicGF5bG9hZCI6eyJsb3lhbHR5Q2xhc3NlcyI6W3siaWQiOiIzMzg4MDAwMDAwMDIyODk3MDgxLmxveWFsdHlfY2xhc3NfMyIsImlzc3Vlck5hbWUiOiJTdGFtcCBMb3lhbHR5IiwicHJvZ3JhbU5hbWUiOiJNZW1iZXIgQ2FyZCIsImxvY2FsaXplZElzc3Vlck5hbWUiOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IlN0YW1wIExveWFsdHkifX0sImxvY2FsaXplZFByb2dyYW1OYW1lIjp7ImRlZmF1bHRWYWx1ZSI6eyJsYW5ndWFnZSI6ImVuLVVTIiwidmFsdWUiOiJNZW1iZXIgQ2FyZCJ9fSwicmV2aWV3U3RhdHVzIjoiVU5ERVJfUkVWSUVXIiwiaGV4QmFja2dyb3VuZENvbG9yIjoiI0ZGRkZGRiIsImNsYXNzVGVtcGxhdGVJbmZvIjp7ImNhcmRUZW1wbGF0ZU92ZXJyaWRlIjp7ImNhcmRSb3dUZW1wbGF0ZUluZm9zIjpbeyJ0d29JdGVtcyI6eyJzdGFydEl0ZW0iOnsiZmlyc3RWYWx1ZSI6eyJmaWVsZHMiOlt7ImZpZWxkUGF0aCI6Im9iamVjdC50ZXh0TW9kdWxlc0RhdGFbJ21lbWJlcl9uYW1lJ10ifV19fSwiZW5kSXRlbSI6eyJmaXJzdFZhbHVlIjp7ImZpZWxkcyI6W3siZmllbGRQYXRoIjoib2JqZWN0LnRleHRNb2R1bGVzRGF0YVsncmV3YXJkX2F2YWlsYWJsZSddIn1dfX19fV19fSwicHJvZ3JhbUxvZ28iOnsic291cmNlVXJpIjp7InVyaSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9pbWFnZXMvYnJhbmQtaW1hZ2VzL3N0YW1wbWVsb2dvLnBuZyJ9LCJjb250ZW50RGVzY3JpcHRpb24iOnsiZGVmYXVsdFZhbHVlIjp7Imxhbmd1YWdlIjoiZW4tVVMiLCJ2YWx1ZSI6IlByb2dyYW0gbG9nbyJ9fX19XSwibG95YWx0eU9iamVjdHMiOlt7ImlkIjoiMzM4ODAwMDAwMDAyMjg5NzA4MS5iZTZjM2I4Ni1hNjI3LTQwNDQtODFlNC0xYTdiNTk1MWE0NTktNmExZTM0YmQxM2RkMyIsImNsYXNzSWQiOiIzMzg4MDAwMDAwMDIyODk3MDgxLmxveWFsdHlfY2xhc3NfMyIsInN0YXRlIjoiQUNUSVZFIiwiYmFyY29kZSI6eyJ0eXBlIjoiQ09ERV8xMjgiLCJ2YWx1ZSI6IjAwMDBUNkdEIiwiYWx0ZXJuYXRlVGV4dCI6IjAwMDBUNkdEIn0sInRleHRNb2R1bGVzRGF0YSI6W3siaWQiOiJtZW1iZXJfbmFtZSIsImhlYWRlciI6Ik1lbWJlciBOYW1lIiwiYm9keSI6IlJvaGFuIn0seyJpZCI6InJld2FyZF9hdmFpbGFibGUiLCJoZWFkZXIiOiJSZXdhcmQgYXZhaWxhYmxlIiwiYm9keSI6IjAifV19XX19.jX7Al8Gdi8f4YVTCKOj3YUh7bKwSFknbt8tfYWUvBwbUQwJvXB6Uwlf4MD6YiIHSv8OMHZ1ygkoXRWSUFAQXMydA0M-9EAjsMkx8SzSwNQfprUaPGcfsXsAybX6EpmebkFdD_9dDAQltm0BinOI7NdvwIFZioLQeL7tkbtVrRMY_cTeUWbPSJe9upIQvhecfxY0-N82AcU55KiINk0A8rfN2zUAIM6uaN-weZ7vo3Fgao_QWh2QpCEq706VwJjWF_M46GaU5aiy1vhKTXv9puPK6SZ1c1cgGrxfE_umxwzr6kok7T5XY5ye6-6fOMI9hLKEFaYC_XPzZkLpjnrWLuA';
  bool? _available = false;
  String _text = 'Loading';

  @override
  void initState() {
    super.initState();
    _checkAvailable();
  }

  void _checkAvailable() async {
    bool? available;
    String text;
    try {
      available = await googleWallet.isAvailable();
      text = "Google Wallet is available: $available";
    } on PlatformException catch (e) {
      text = "Error: '${e.message}'.";
    }
    setState(() {
      _available = available;
      _text = text;
    });
  }

  Future<void> _savePassBrowser() async {
    String url = "https://pay.google.com/gp/v/save/$jwt";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not open Google Wallet via web';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GoogleWalletButton(
              style: GoogleWalletButtonStyle.button,
              height: 56,
              onPressed: _available == true
                  ? () => googleWallet.savePassesJwt(jwt)
                  : _savePassBrowser,
            ),
            Text(_text),
          ],
        ),
      ),
    );
  }
}
