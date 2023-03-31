import 'package:firstapp/controllers/cart_controller.dart';
import 'package:firstapp/controllers/popular_product_controller.dart';
import 'package:firstapp/controllers/recommended_product_controller.dart';
import 'package:firstapp/routes/route_helper.dart';
import 'package:firstapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'helper/dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (_) {
      return GetBuilder<PopularProductController>(builder: (_) {
        return GetBuilder<RecommendedProductController>(builder: (_) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Laziz',
            //home: SignInPage(),
            initialRoute: RouteHelper.getSplashPage(),
            getPages: RouteHelper.routes,
            theme: ThemeData(primaryColor: AppColors.mainColor, fontFamily: "Lato"),
          );
        });
      });
    });
  }
}
