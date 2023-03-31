// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firstapp/base/custom_button.dart';
import 'package:firstapp/controllers/location_controller.dart';
import 'package:firstapp/models/address_model.dart';
import 'package:firstapp/routes/route_helper.dart';
import 'package:firstapp/util/colors.dart';
import 'package:firstapp/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickAddressMap extends StatefulWidget {
  final bool fromSignup;
  final bool fromAddress;
  final GoogleMapController? googleMapController;
  const PickAddressMap(
      {super.key, required this.fromSignup, required this.fromAddress, this.googleMapController});

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.find<LocationController>().addressList.isEmpty) {
      _initialPosition = LatLng(22.324574208692447, 73.18175349760536);
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    } else {
      if (Get.find<LocationController>().addressList.isNotEmpty) {
        _initialPosition = LatLng(
            double.parse(Get.find<LocationController>().getAddress["latitude"]),
            double.parse(Get.find<LocationController>().getAddress["longitude"]));
        _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      return Scaffold(
          body: SafeArea(
              child: Center(
                  child: SizedBox(
        width: double.maxFinite,
        child: Stack(children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 17),
            zoomControlsEnabled: false,
            onCameraMove: (CameraPosition cameraPosition) {
              _cameraPosition = cameraPosition;
            },
            onCameraIdle: () {
              Get.find<LocationController>().updatePosition(_cameraPosition, false);
            },
          ),
          Center(
              child: !locationController.loading
                  ? Image.asset(
                      "assets/image/pick_marker.png",
                      height: Dimensions.height10 * 5,
                      width: Dimensions.height10 * 5,
                    )
                  : const CircularProgressIndicator()),
          Positioned(
            top: Dimensions.height45,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              height: Dimensions.height10 * 8,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(Dimensions.radius20 / 2)),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 30,
                    color: AppColors.iconColor2,
                  ),
                  Expanded(
                      child: Text(
                    '${locationController.pickPlacemark.name ?? ''}',
                    style: TextStyle(color: AppColors.mainBlackColor, fontSize: Dimensions.font20),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              ),
            ),
          ),
          Positioned(
              bottom: Dimensions.height20 * 5,
              left: Dimensions.width20,
              right: Dimensions.width20,
              child: locationController.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CustomButton(
                      width: Dimensions.width20 * 10,
                      height: Dimensions.height10 * 7,
                      fontSize: Dimensions.font20,
                      radius: Dimensions.radius20,
                      buttonText: locationController.inZone
                          ? widget.fromAddress
                              ? 'Pick Address'
                              : 'Pick Location'
                          : 'Service not available',
                      onPressed: (locationController.buttonDisabled || locationController.loading)
                          ? null
                          : () {
                              if (locationController.pickPosition.latitude != 0 &&
                                  locationController.pickPlacemark.name != null) {
                                if (widget.fromAddress) {
                                  if (widget.googleMapController != null) {
                                    widget.googleMapController!.moveCamera(
                                        CameraUpdate.newCameraPosition(CameraPosition(
                                            target: LatLng(locationController.pickPosition.latitude,
                                                locationController.pickPosition.longitude))));
                                    locationController.setAddressData();
                                  }
                                  Get.back();
                                  //Get.toNamed(RouteHelper.getAddressPage());
                                }
                              }
                            },
                    ))
        ]),
      ))));
    });
  }
}
