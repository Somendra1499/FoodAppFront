// ignore_for_file: avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'package:firstapp/base/custom_loader.dart';
import 'package:firstapp/controllers/auth_controller.dart';
import 'package:firstapp/controllers/cart_controller.dart';
import 'package:firstapp/controllers/location_controller.dart';
import 'package:firstapp/controllers/user_controller.dart';
import 'package:firstapp/routes/route_helper.dart';
import 'package:firstapp/util/colors.dart';
import 'package:firstapp/util/dimensions.dart';
import 'package:firstapp/widgets/account_widget.dart';
import 'package:firstapp/widgets/app_icon.dart';
import 'package:firstapp/widgets/big_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUserInfo();
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: BigText(
            text: "Profile",
            size: 24,
            color: Colors.white,
          ),
        ),
        body: GetBuilder<UserController>(builder: (userController) {
          return _userLoggedIn
              ? (userController.isLoading
                  ? Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(top: Dimensions.height20),
                      child: Column(children: [
                        AppIcon(
                            icon: Icons.person,
                            backgroundColor: AppColors.mainColor,
                            iconColor: Colors.white,
                            iconSize: Dimensions.height15 * 5,
                            size: Dimensions.height10 * 15),
                        SizedBox(
                          height: Dimensions.height30,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                AccountWidget(
                                    appIcon: AppIcon(
                                        icon: Icons.person,
                                        backgroundColor: AppColors.mainColor,
                                        iconColor: Colors.white,
                                        iconSize: Dimensions.height10 * 2.5,
                                        size: Dimensions.height10 * 5),
                                    bigText: BigText(
                                      text: userController.userModel.name,
                                    )),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                AccountWidget(
                                    appIcon: AppIcon(
                                        icon: Icons.phone,
                                        backgroundColor: AppColors.yellowColor,
                                        iconColor: Colors.white,
                                        iconSize: Dimensions.height10 * 2.5,
                                        size: Dimensions.height10 * 5),
                                    bigText: BigText(
                                      text: userController.userModel.phone,
                                    )),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                AccountWidget(
                                    appIcon: AppIcon(
                                        icon: Icons.email,
                                        backgroundColor: AppColors.yellowColor,
                                        iconColor: Colors.white,
                                        iconSize: Dimensions.height10 * 2.5,
                                        size: Dimensions.height10 * 5),
                                    bigText: BigText(
                                      text: userController.userModel.email,
                                    )),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                GetBuilder<LocationController>(builder: (locationController) {
                                  if (_userLoggedIn && locationController.addressList.isEmpty) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.offNamed(RouteHelper.getAddressPage());
                                      },
                                      child: AccountWidget(
                                          appIcon: AppIcon(
                                              icon: Icons.location_on,
                                              backgroundColor: AppColors.yellowColor,
                                              iconColor: Colors.white,
                                              iconSize: Dimensions.height10 * 2.5,
                                              size: Dimensions.height10 * 5),
                                          bigText: BigText(
                                            text: "Fill in your address",
                                          )),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.offNamed(RouteHelper.getAddressPage());
                                      },
                                      child: AccountWidget(
                                          appIcon: AppIcon(
                                              icon: Icons.location_on,
                                              backgroundColor: AppColors.yellowColor,
                                              iconColor: Colors.white,
                                              iconSize: Dimensions.height10 * 2.5,
                                              size: Dimensions.height10 * 5),
                                          bigText: BigText(
                                            text: "Saved Address",
                                          )),
                                    );
                                  }
                                }),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                AccountWidget(
                                    appIcon: AppIcon(
                                        icon: Icons.message,
                                        backgroundColor: Colors.redAccent,
                                        iconColor: Colors.white,
                                        iconSize: Dimensions.height10 * 2.5,
                                        size: Dimensions.height10 * 5),
                                    bigText: BigText(
                                      text: "Messages",
                                    )),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (Get.find<AuthController>().userLoggedIn()) {
                                      Get.find<AuthController>().clearSharedData();
                                      Get.find<CartController>().clear();
                                      Get.find<CartController>().clearCartHistory();
                                      Get.find<LocationController>().clearAddressList();
                                      Get.offNamed(RouteHelper.getSignInPage());
                                    } else {
                                      Get.snackbar("Authentication", "Logged Out!",
                                          backgroundColor: AppColors.mainColor,
                                          colorText: Colors.black);
                                    }
                                  },
                                  child: AccountWidget(
                                      appIcon: AppIcon(
                                          icon: Icons.logout,
                                          backgroundColor: Colors.redAccent,
                                          iconColor: Colors.white,
                                          iconSize: Dimensions.height10 * 2.5,
                                          size: Dimensions.height10 * 5),
                                      bigText: BigText(
                                        text: "Log Out",
                                      )),
                                ),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                    )
                  : const CustomLoader())
              : Container(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: Dimensions.height20 * 10,
                        margin:
                            EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/image/signintocontinue.png"))),
                      ),
                      SizedBox(
                        height: Dimensions.height30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteHelper.getSignInPage());
                        },
                        child: Container(
                          width: Dimensions.width30 * 8,
                          height: Dimensions.height20 * 5,
                          margin:
                              EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                          ),
                          child: Center(
                            child: BigText(
                              text: "Sign In",
                              color: Colors.white,
                              size: Dimensions.font26,
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                );
        }));
  }
}
