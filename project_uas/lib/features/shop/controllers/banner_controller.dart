import 'package:get/get.dart';
import 'package:project_uas/data/banner/banner_repository.dart';
import 'package:project_uas/features/shop/models/banner_model.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class BannerController extends GetxController {

  // variabel
  final isLoading = false.obs;
  final carousalcurrentIndex = 0.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;

  @override
  void onInit() {
    fetchBanner();
    super.onInit();
  }

  void updatePageIndicator(index) {
    carousalcurrentIndex.value = index;
  }

  // fetch banner
  Future<void> fetchBanner() async {
    try {
      // Show Loader while loading categories
      isLoading.value = true;

      // Fetch Banners
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fetchBanners();

      // Assign Banners
      this.banners.assignAll(banners);

    } catch (e) {
      BLoaders.errorSnackBar (title: 'Oh Snap! ', message: e.toString());
    } finally {
      //Remove Loader
      isLoading.value = false;
    }
  }
}