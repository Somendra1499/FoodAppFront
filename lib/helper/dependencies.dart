import 'package:firstapp/controllers/auth_controller.dart';
import 'package:firstapp/controllers/location_controller.dart';
import 'package:firstapp/controllers/user_controller.dart';
import 'package:firstapp/data/repository/auth_repo.dart';
import 'package:firstapp/data/repository/location_repo.dart';
import 'package:firstapp/data/repository/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstapp/controllers/cart_controller.dart';
import 'package:firstapp/controllers/popular_product_controller.dart';
import 'package:firstapp/controllers/recommended_product_controller.dart';
import 'package:firstapp/data/api/api_client.dart';
import 'package:firstapp/data/repository/cart_repo.dart';
import 'package:firstapp/data/repository/popular_product_repo.dart';
import 'package:firstapp/data/repository/recommended_product_repo.dart';
import 'package:firstapp/util/app_constants.dart';
import 'package:get/get.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);
  //for api clients
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL,
      sharedPreferences: Get.find())); //sharedPreferences: Get.find()
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));

  //for repos
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  //for controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
  Get.lazyPut(() => RecommendedProductController(recommendedProductRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
}
