// ignore_for_file: no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, sort_child_properties_last, prefer_const_constructors, prefer_is_empty

import 'package:firstapp/base/no_data_page.dart';
import 'package:firstapp/controllers/auth_controller.dart';
import 'package:firstapp/controllers/cart_controller.dart';
import 'package:firstapp/controllers/location_controller.dart';
import 'package:firstapp/controllers/popular_product_controller.dart';
import 'package:firstapp/controllers/recommended_product_controller.dart';
import 'package:firstapp/routes/route_helper.dart';
import 'package:firstapp/util/app_constants.dart';
import 'package:firstapp/util/colors.dart';
import 'package:firstapp/util/dimensions.dart';
import 'package:firstapp/widgets/app_icon.dart';
import 'package:firstapp/widgets/big_text.dart';
import 'package:firstapp/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
                left: Dimensions.width20,
                right: Dimensions.width20,
                top: Dimensions.height20 * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getInitial());
                      },
                      child: AppIcon(
                        icon: Icons.arrow_back_ios_new,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        iconSize: Dimensions.iconSize24,
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.width20 * 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getInitial());
                      },
                      child: AppIcon(
                        icon: Icons.home_outlined,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        iconSize: Dimensions.iconSize24,
                      ),
                    ),
                    AppIcon(
                      icon: Icons.shopping_cart_outlined,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    )
                  ],
                )),
            GetBuilder<CartController>(builder: (_cartController) {
              return _cartController.getItems.length > 0
                  ? Positioned(
                      top: Dimensions.height20 * 5,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.height15),
                        //color: Colors.red,
                        child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GetBuilder<CartController>(
                              builder: (cartController) {
                                var _cartList = cartController.getItems;
                                return ListView.builder(
                                    itemCount: _cartList.length,
                                    itemBuilder: (_, index) {
                                      return Container(
                                        height: Dimensions.height20 * 5,
                                        width: double.maxFinite,
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var popularIndex =
                                                    Get.find<PopularProductController>()
                                                        .popularProductList
                                                        .indexOf(_cartList[index].product!);
                                                if (popularIndex >= 0) {
                                                  Get.toNamed(RouteHelper.getPopularFood(
                                                      popularIndex, "cartpage"));
                                                } else {
                                                  var recommendedIndex =
                                                      Get.find<RecommendedProductController>()
                                                          .recommendedProductList
                                                          .indexOf(_cartList[index].product!);
                                                  if (recommendedIndex < 0) {
                                                    Get.snackbar("History Product",
                                                        "Product review is not availble for history products !",
                                                        backgroundColor: AppColors.mainColor,
                                                        colorText: Colors.black);
                                                  } else {
                                                    Get.toNamed(RouteHelper.getRecommendedFood(
                                                        recommendedIndex, "cartpage"));
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: Dimensions.height20 * 5,
                                                height: Dimensions.height20 * 5,
                                                margin:
                                                    EdgeInsets.only(bottom: Dimensions.height10),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(AppConstants.BASE_URL +
                                                            AppConstants.UPLOAD_URL +
                                                            cartController.getItems[index].img!)),
                                                    borderRadius:
                                                        BorderRadius.circular(Dimensions.radius20),
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                              width: Dimensions.width10,
                                            ),
                                            Expanded(
                                                child: Container(
                                              height: Dimensions.height20 * 5,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  BigText(
                                                    text: cartController.getItems[index].name!,
                                                    color: Colors.black54,
                                                  ),
                                                  SmallText(text: "Spicy"),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      BigText(
                                                        text:
                                                            "\u{20B9} ${cartController.getItems[index].price! * cartController.getItems[index].quantity! * 10}",
                                                        color: Colors.redAccent,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            top: Dimensions.height10,
                                                            bottom: Dimensions.height10,
                                                            left: Dimensions.width10,
                                                            right: Dimensions.width10),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(
                                                              Dimensions.radius20),
                                                          color: Colors.white,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                cartController.addItem(
                                                                    _cartList[index].product!, -1);
                                                              },
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: AppColors.signColor,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: Dimensions.width10 / 2,
                                                            ),
                                                            BigText(
                                                                text: _cartList[index]
                                                                    .quantity
                                                                    .toString()), //popularProduct.inCartItems.toString()),
                                                            SizedBox(
                                                              width: Dimensions.width10 / 2,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                cartController.addItem(
                                                                    _cartList[index].product!, 1);
                                                              },
                                                              child: Icon(
                                                                Icons.add,
                                                                color: AppColors.signColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ))
                                          ],
                                        ),
                                      );
                                    });
                              },
                            )),
                      ))
                  : NoDataPage(text: "Your cart is empty !");
            })
          ],
        ),
        bottomNavigationBar: GetBuilder<CartController>(
          builder: (cartController) {
            return Container(
              height: Dimensions.bottomHeightBar,
              padding: EdgeInsets.only(
                  top: Dimensions.height30,
                  bottom: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20),
              decoration: BoxDecoration(
                  color: AppColors.buttonBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20 * 2),
                    topRight: Radius.circular(Dimensions.radius20 * 2),
                  )),
              child: cartController.getItems.length > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.height20,
                              bottom: Dimensions.height20,
                              left: Dimensions.width20,
                              right: Dimensions.width20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: Dimensions.width10 / 2,
                              ),
                              BigText(
                                  text: "Total: \u{20B9} ${cartController.totalAmount.toString()}"),
                              SizedBox(
                                width: Dimensions.width10 / 2,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (Get.find<AuthController>().userLoggedIn()) {
                              if (Get.find<LocationController>().addressList.isEmpty) {
                                Get.toNamed(RouteHelper.getAddressPage());
                              } else {
                                Get.offNamed(RouteHelper.getInitial());
                              }
                              //cartController.addToHistory();
                            } else {
                              Get.toNamed(RouteHelper.getSignInPage());
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: Dimensions.height20,
                                bottom: Dimensions.height20,
                                left: Dimensions.width20,
                                right: Dimensions.width20),
                            child: BigText(
                              text: "Check Out",
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                              color: AppColors.mainColor,
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(),
            );
          },
        ));
  }
}
