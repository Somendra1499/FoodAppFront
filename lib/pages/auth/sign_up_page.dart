// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:firstapp/base/custom_loader.dart';
import 'package:firstapp/base/show_custom_snackbar.dart';
import 'package:firstapp/controllers/auth_controller.dart';
import 'package:firstapp/models/signup_body_model.dart';
import 'package:firstapp/pages/auth/sign_in_page.dart';
import 'package:firstapp/routes/route_helper.dart';
import 'package:firstapp/util/colors.dart';
import 'package:firstapp/util/dimensions.dart';
import 'package:firstapp/widgets/app_texts_field.dart';
import 'package:firstapp/widgets/big_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var signUpImages = ["t.png", "f.png", "g.png"];

    void _registration(AuthController authController) {
      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (name.isEmpty) {
        showCustomSnackBar("Type in your name", title: "Name");
      } else if (!GetUtils.isAlphabetOnly(name)) {
        showCustomSnackBar("Name format is not correct", title: "Name");
      } else if (phone.isEmpty) {
        showCustomSnackBar("Type in your phone number", title: "Phone");
      } else if (!GetUtils.isNumericOnly(phone)) {
        showCustomSnackBar("Phone number format is not correct", title: "Phone");
      } else if (phone.length != 10) {
        showCustomSnackBar("Phone number format is not correct", title: "Phone");
      } else if (email.isEmpty) {
        showCustomSnackBar("Type in your email", title: "Email");
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar("Email format is not correct", title: "Email");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomSnackBar("Password length should be more then 6 charecters", title: "Password");
      } else {
        SignUpBody signUpBody =
            SignUpBody(name: name, phone: phone, email: email, password: password);
        authController.registration(signUpBody).then((status) {
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
        body: GetBuilder<AuthController>(builder: (_authController) {
          return !_authController.isLoading
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
                      AppTextField(
                          textController: emailController, hintText: "Email", icon: Icons.email),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextField(
                          textController: passwordController,
                          hintText: "Password",
                          icon: Icons.password_sharp,
                          isObscure: true),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextField(
                          textController: nameController, hintText: "Name", icon: Icons.person),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextField(
                          textController: phoneController, hintText: "Phone", icon: Icons.phone),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _registration(_authController);
                        },
                        child: Container(
                          width: Dimensions.screenWidth / 2,
                          height: Dimensions.screenHeight / 13,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius30),
                              color: AppColors.mainColor),
                          child: Center(
                            child: BigText(
                              text: "Sign Up",
                              size: Dimensions.font20 / 2 + Dimensions.font20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Have an account already? ",
                              style:
                                  TextStyle(color: Colors.grey[500], fontSize: Dimensions.font20),
                              children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      Get.to(() => const SignInPage(), transition: Transition.fade),
                                text: "Login",
                                style: TextStyle(
                                    color: AppColors.mainBlackColor,
                                    fontSize: Dimensions.font20,
                                    fontWeight: FontWeight.bold))
                          ])),
                      SizedBox(
                        height: Dimensions.screenHeight * 0.005,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Login using following method",
                              style:
                                  TextStyle(color: Colors.grey[500], fontSize: Dimensions.font16))),
                      Wrap(
                        children: List.generate(
                            3,
                            (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: Dimensions.radius30,
                                    backgroundImage:
                                        AssetImage("assets/image/" + signUpImages[index]),
                                  ),
                                )),
                      )
                    ],
                  ),
                )
              : const CustomLoader();
        }));
  }
}
