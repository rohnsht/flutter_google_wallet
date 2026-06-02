import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'flutter_google_wallet_platform_interface.dart';

class FlutterGoogleWallet {
  Future<bool?> isAvailable() {
    return FlutterGoogleWalletPlatform.instance.isAvailable();
  }

  Future<bool?> savePasses(String passJson) {
    return FlutterGoogleWalletPlatform.instance.savePasses(passJson);
  }

  Future<bool?> savePassesJwt(String passJwt) {
    return FlutterGoogleWalletPlatform.instance.savePassesJwt(passJwt);
  }
}

enum GoogleWalletButtonStyle { button, badge }

extension GoogleWalletButtonStyleExtension on GoogleWalletButtonStyle {
  String get value {
    switch (this) {
      case GoogleWalletButtonStyle.button:
        return 'wallet_button';
      case GoogleWalletButtonStyle.badge:
        return 'add_wallet_badge';
    }
  }
}

class GoogleWalletButton extends StatefulWidget {
  static const double _minHeight = 48;
  static const _defaultLocaleName = 'en_US';
  static const _supportedLocaleNames = [
    'af',
    'am',
    'ar',
    'az',
    'bg',
    'bn',
    'br',
    'bs',
    'by',
    'ca',
    'cz',
    'de',
    'dk',
    'en_AU',
    'en_CA',
    'en_GB',
    'en_IN',
    'en_SG',
    'en_US',
    'en_ZA',
    'es_419',
    'es_ES',
    'es_US',
    'et',
    'fa',
    'fl',
    'fp',
    'fr_CA',
    'fr_FR',
    'gr',
    'he',
    'hr',
    'hu',
    'hy',
    'id',
    'is',
    'it',
    'jp',
    'ka',
    'kh',
    'kk',
    'ky',
    'lo',
    'lt',
    'lv',
    'mk',
    'mn',
    'my',
    'nl',
    'no',
    'pl',
    'pt',
    'ro',
    'ru',
    'se',
    'si',
    'sk',
    'sl',
    'sq',
    'sr',
    'sw',
    'th',
    'tr',
    'uk',
    'uz',
    'vi',
    'zh_HK',
    'zh_TW',
  ];

  final GoogleWalletButtonStyle style;
  final double height;
  final VoidCallback onPressed;
  final Locale? locale;

  const GoogleWalletButton({
    super.key,
    this.style = GoogleWalletButtonStyle.button,
    this.height = _minHeight,
    required this.onPressed,
    this.locale,
  });

  @override
  State<GoogleWalletButton> createState() => _GoogleWalletButtonState();
}

class _GoogleWalletButtonState extends State<GoogleWalletButton> {
  static const double _pressedScale = 0.96;
  bool _isPressed = false;

  // ignore: strict_top_level_inference
  String _assetPath() {
    String localeName = GoogleWalletButton._defaultLocaleName;
    if (widget.locale != null &&
        GoogleWalletButton._supportedLocaleNames.contains(
          widget.locale.toString(),
        )) {
      localeName = widget.locale.toString();
    } else if (GoogleWalletButton._supportedLocaleNames.contains(
      Platform.localeName,
    )) {
      localeName = Platform.localeName;
    }
    return 'assets/${localeName.replaceAll('_', '')}_add_to_google_wallet_${widget.style.value}.svg';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        _isPressed = true;
      }),
      onTapUp: (_) => setState(() {
        _isPressed = false;
      }),
      onTapCancel: () => setState(() {
        _isPressed = false;
      }),
      onTap: widget.onPressed,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        scale: _isPressed ? _pressedScale : 1,
        child: SvgPicture.asset(
          _assetPath(),
          height: max(widget.height, GoogleWalletButton._minHeight),
          fit: BoxFit.cover,
          package: 'flutter_google_wallet',
        ),
      ),
    );
  }
}
