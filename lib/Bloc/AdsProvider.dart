

import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState{
	Future<InitializationStatus> initialisation;
	
	AdState(this.initialisation);
	
	String get bannerAdUnitId => Platform.isAndroid
			?'ca-app-pub-3940256099942544/6300978111'
			:'ca-app-pub-3940256099942544/2934735716';
	
	AdListener get adListener => _adListener;
	
	AdListener _adListener = AdListener(
		onAdLoaded: (ad) => print("Ad loaded"),
		onAdClosed: (ad) => print("Ad closed"),
		onAdFailedToLoad: (ad,error) => print("ad failed to load ${ad.adUnitId} , $error"),
	);
}