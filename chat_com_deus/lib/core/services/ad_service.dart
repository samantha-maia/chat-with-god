import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void loadAndShowRewardedAd({required Function onRewarded, required Function(String) onError}) {
    _isLoading = true;
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _rewardedAd = ad;
          _rewardedAd!.show(
            onUserEarnedReward: (ad, reward) {
              onRewarded();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          onError(error.message);
        },
      ),
    );
  }
} 