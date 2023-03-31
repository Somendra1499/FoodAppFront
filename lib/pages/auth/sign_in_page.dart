// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers

import 'package:firstapp/base/custom_loader.dart';
import 'package:firstapp/base/show_custom_snackbar.dart';
import 'package:firstapp/controllers/auth_controller.dart';
import 'package:firstapp/models/signin_body_model.dart';
import 'package:firstapp/pages/auth/sign_up_page.dart';
import 'package:firstapp/routes/route_helper.dart';
import 'package:firstapp/util/colors.dart';
import 'package:firstapp/util/dimensions.dart';
import 'package:firstapp/widgets/app_texts_field.dart';
import 'package:firstapp/widgets/big_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var passwordController = TextEditingController();

    void _login(AuthController authController) {
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      if (phone.isEmpty) {
        showCustomSnackBar("Type in your phone", title: "Phone");
      } else if (!GetUtils.isNumericOnly(phone)) {
        showCustomSnackBar("Phone number format is not correct", title: "Phone");
      } else if (phone.length != 10) {
        showCustomSnackBar("Phone number format is not correct", title: "Phone");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomSnackBar("Password length should be more then 6 charecters", title: "Password");
      } else {
        SignInBody signInBody = SignInBody(phone: phone, password: password);
        authController.login(signInBody).then((status) {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<AuthController>(builder: (authController) {
          return !authController.isLoading
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Dimensions.screenHeight * 0.05,
                      ),
                      Container(
                        height: Dimensions.screenHeight * 0.25,
                        child: const Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 80,
                            backgroundImage: AssetImage("assets/image/logo part 1.png"),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: Dimensions.width20),
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello",
                              style: TextStyle(
                                  fontSize: Dimensions.font20 * 3 + Dimensions.font20 / 2,
                                  fontWeight: FontWeight.bold),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: "Sign into your account",
                                    style: TextStyle(
                                        color: Colors.grey[500], fontSize: Dimensions.font20))),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.screenHeight * 0.05,
                      ),
                      AppTextField(
                          textController: phoneController, hintText: "Phone", icon: Icons.phone),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextField(
                          textController: passwordController,
                          hintText: "Password",
                          icon: Icons.password_sharp,
                          isObscure: true),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          RichText(
                              text: TextSpan(
                                  text: "Sign into your account",
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: Dimensions.font20))),
                          SizedBox(
                            width: Dimensions.width20,
                          )
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.screenHeight * 0.05,
                      ),
                      GestureDetector(
                        onTap: () {
                          _login(authController);
                        },
                        child: Container(
                          width: Dimensions.screenWidth / 2,
                          height: Dimensions.screenHeight / 13,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius30),
                              color: AppColors.mainColor),
                          child: Center(
                            child: BigText(
                              text: "Sign In",
                              size: Dimensions.font20 / 2 + Dimensions.font20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.screenHeight * 0.05,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Don't have an account?",
                              style:
                                  TextStyle(color: Colors.grey[500], fontSize: Dimensions.font20),
                              children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      Get.to(() => const SignUpPage(), transition: Transition.fade),
                                text: " Create",
                                style: TextStyle(
                                    color: AppColors.mainBlackColor,
                                    fontSize: Dimensions.font20,
                                    fontWeight: FontWeight.bold))
                          ])),
                    ],
                  ),
                )
              : const CustomLoader();
        }));
  }
}
