

import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState{
	Future<InitializationStatus> initialisation;
	
	AdState(this.initialisation);
	
	String get bannerAdUnitId => 'ca-app-pub-4569649492742996/8555084850';
	
	BannerAdListener get adListener => _adListener;
	
	BannerAdListener _adListener = BannerAdListener(
		onAdLoaded: (ad) => print("Ad loaded"),
		onAdClosed: (ad) => print("Ad closed"),
		onAdFailedToLoad: (ad,error) => print("ad failed to load ${ad.adUnitId} , $error"),
	);
}