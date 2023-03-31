// ignore_for_file: sized_box_for_whitespace, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, prefer_is_empty, prefer_collection_literals

import 'dart:convert';

import 'package:firstapp/base/no_data_page.dart';
import 'package:firstapp/controllers/cart_controller.dart';
import 'package:firstapp/models/cart_Model.dart';
import 'package:firstapp/routes/route_helper.dart';
import 'package:firstapp/util/app_constants.dart';
import 'package:firstapp/util/colors.dart';
import 'package:firstapp/util/dimensions.dart';
import 'package:firstapp/widgets/app_icon.dart';
import 'package:firstapp/widgets/big_text.dart';
import 'package:firstapp/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({super.key});

  @override
  Widget build(BuildContext context) {
    var getCartHistoryList = Get.find<CartController>().getCartHistoryList().reversed.toList();

    Map<String, int> cartItemsPerOrder = Map();
    for (int i = 0; i < getCartHistoryList.length; i++) {
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
        cartItemsPerOrder.update(getCartHistoryList[i].time!, (value) => ++value);
      } else {
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
      }
    }
    List<int> cartItemsPerOrderToList() {
      return cartItemsPerOrder.entries.map((e) {
        return e.value;
      }).toList();
    }

    List<String> cartOrderTimeToList() {
      return cartItemsPerOrder.entries.map((e) {
        return e.key;
      }).toList();
    }

    List<int> itemsPerOrder = cartItemsPerOrderToList();

    var listCounter = 0;

    Widget timeWidget(int index) {
      var outputDate = DateTime.now().toString();
      if (index < getCartHistoryList.length) {
        DateTime parseDate =
            DateFormat("yyyy-MM-dd HH:mm:ss").parse(getCartHistoryList[listCounter].time!);
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat = DateFormat("dd/MM/yyyy hh:mm a");
        outputDate = outputFormat.format(inputDate);
      }
      return BigText(
        text: outputDate,
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.mainColor,
            height: Dimensions.height10 * 10,
            width: double.maxFinite,
            padding: EdgeInsets.only(top: Dimensions.height45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BigText(
                  text: "Your Cart History",
                  color: Colors.white,
                ),
                AppIcon(
                  icon: Icons.shopping_cart_outlined,
                  iconColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  iconSize: Dimensions.iconSize24,
                )
              ],
            ),
          ),
          GetBuilder<CartController>(builder: (_cartController) {
            return _cartController.getCartHistoryList().length > 0
                ? Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: Dimensions.height20,
                          left: Dimensions.width20,
                          right: Dimensions.width20),
                      child: MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView(
                            children: [
                              for (int i = 0; i < itemsPerOrder.length; i++)
                                Container(
                                  height: Dimensions.height30 * 4,
                                  margin: EdgeInsets.only(bottom: Dimensions.height20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      timeWidget(listCounter),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Wrap(
                                            direction: Axis.horizontal,
                                            children: List.generate(itemsPerOrder[i], (index) {
                                              if (listCounter < getCartHistoryList.length) {
                                                listCounter++;
                                              }
                                              return index <= 2
                                                  ? Container(
                                                      height: Dimensions.height20 * 4,
                                                      width: Dimensions.height20 * 4,
                                                      margin: EdgeInsets.only(
                                                          right: Dimensions.width10 / 2),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(
                                                              Dimensions.radius15 / 2),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  AppConstants.BASE_URL +
                                                                      AppConstants.UPLOAD_URL +
                                                                      getCartHistoryList[
                                                                              listCounter - 1]
                                                                          .img!))),
                                                    )
                                                  : Container();
                                            }),
                                          ),
                                          Container(
                                            height: Dimensions.height20 * 4,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                SmallText(
                                                  text: "Total",
                                                  color: AppColors.titleColor,
                                                ),
                                                BigText(
                                                  text: itemsPerOrder[i].toString() + " Item",
                                                  color: AppColors.titleColor,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    var orderTime = cartOrderTimeToList();
                                                    Map<int, CartModel> moreOrder = {};
                                                    for (int j = 0;
                                                        j < getCartHistoryList.length;
                                                        j++) {
                                                      if (getCartHistoryList[j].time ==
                                                          orderTime[i]) {
                                                        moreOrder.putIfAbsent(
                                                            getCartHistoryList[j].id!,
                                                            () => CartModel.fromJson(jsonDecode(
                                                                jsonEncode(
                                                                    getCartHistoryList[j]))));
                                                      }
                                                    }
                                                    Get.find<CartController>().setItems = moreOrder;
                                                    Get.find<CartController>().addToCartList();
                                                    Get.toNamed(RouteHelper.getCartPage());
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimensions.width10,
                                                        vertical: Dimensions.height10 / 2),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          Dimensions.radius20 / 4),
                                                      border: Border.all(
                                                          width: 1, color: AppColors.mainColor),
                                                    ),
                                                    child: SmallText(
                                                      text: "One more",
                                                      color: AppColors.mainColor,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ],
                          )),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: const Center(
                      child: NoDataPage(
                        text: "You have no shopping history!",
                        imgPath: "assets/image/empty_box.png",
                      ),
                    ),
                  );
          })
        ],
      ),
    );
  }
}
