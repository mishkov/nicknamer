import 'dart:io';

class AdMobService {
  String? getAdMobAppId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7893747770236345~9356173048';
    } else {
      return null;
    }
  }

  String? getMainPageBannerAdId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7893747770236345/2407621315';
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