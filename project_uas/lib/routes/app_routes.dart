import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:project_uas/features/authentication/controllers/onboarding/onboarding.dart';
import 'package:project_uas/features/authentication/screens/login/login.dart';
import 'package:project_uas/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:project_uas/features/authentication/screens/signup.widgets/signup.dart';
import 'package:project_uas/features/authentication/screens/signup.widgets/verify_email.dart';
import 'package:project_uas/features/personalization/screens/profile/profile.dart';
import 'package:project_uas/features/personalization/screens/settings/settings.dart';
import 'package:project_uas/features/shop/screens/cart/cart.dart';
import 'package:project_uas/features/shop/screens/checkout/checkout.dart';
import 'package:project_uas/features/shop/screens/home/home.dart';
import 'package:project_uas/features/shop/screens/order/order.dart';
import 'package:project_uas/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:project_uas/features/shop/screens/store/store.dart';
import 'package:project_uas/features/shop/screens/wishlist/wishlist.dart';
import 'package:project_uas/routes/routes.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: BRoutes.home, page: () => const HomeScreen ()),
    GetPage(name: BRoutes.store, page: () => const StoreScreen()),
    GetPage(name: BRoutes.favourites, page: () => const FavoriteScreen()),
    GetPage(name: BRoutes.settings, page: () => const SettingsScreen()),
    GetPage(name: BRoutes.productReviews, page: () => const ProductReviewsScreen()),
    GetPage(name: BRoutes.order, page: () => const OrderScreen()),
    GetPage(name: BRoutes.checkout, page: () => const CheckoutScreen()),
    GetPage(name: BRoutes.cart, page: () => const CartScreen ()),
    GetPage(name: BRoutes.userProfile, page: () => const ProfileScreen()),
    // GetPage(name: BRoutes.userAddress, page: () => const UserAddressScreen()),
    GetPage(name: BRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: BRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: BRoutes.signIn, page: () => const LoginScreen()),
    GetPage(name: BRoutes.forgetPassword, page: () => const ForgetPassword()),
    GetPage(name: BRoutes.onBoarding, page: () => const OnBoardingScreen()),
  ];
}