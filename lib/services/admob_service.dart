import 'dart:io';

class AdMobService {
  String? getAdMobAppId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8743953761460890~5808507131';
    } else {
      return null;
    }
  }

  String? getMainPageBannerAdId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8743953761460890/8051527095';
    } else {
      return null;
    }
  }

  String? getTestBannerAdId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      return null;
    }
  }
}