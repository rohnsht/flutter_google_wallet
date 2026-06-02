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

class GoogleWalletButton extends StatelessWidget {
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
  final VoidCallback? onPressed;
  final Locale? locale;

  const GoogleWalletButton({
    super.key,
    this.style = GoogleWalletButtonStyle.button,
    this.height = _minHeight,
    this.onPressed,
    this.locale,
  });

  // ignore: strict_top_level_inference
  String _assetPath(context) {
    String localeName = _defaultLocaleName;
    if (locale != null && _supportedLocaleNames.contains(locale.toString())) {
      localeName = locale.toString();
    } else if (_supportedLocaleNames.contains(Platform.localeName)) {
      localeName = Platform.localeName;
    }
    return 'assets/${localeName.replaceAll('_', '')}_add_to_google_wallet_${style.value}.svg';
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.all(8),
      onPressed: onPressed,
      child: SvgPicture.asset(
        _assetPath(context),
        height: max(height, _minHeight),
        fit: BoxFit.contain,
        package: 'flutter_google_wallet',
      ),
    );
  }
}
