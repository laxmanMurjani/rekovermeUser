import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/location_response_odel.dart';
import 'package:arbyuser/ui/Locationscreen.dart';
import 'package:arbyuser/ui/dialog/address_delete_dialog.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({Key? key}) : super(key: key);

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final UserController _userController = Get.find();
  // String otherAddressData = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      appBar: CustomAppBar(
        text: "saved_addresses".tr,
      ),
      body: GetX<UserController>(
        builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          Home? _homeAddress;
          Home? _workAddress;
          Home? _otherAddress;

          if (cont.locationResponseModel.value.home.isNotEmpty) {
            _homeAddress = cont.locationResponseModel.value.home.last;
          }
          if (cont.locationResponseModel.value.work.isNotEmpty) {
            _workAddress = cont.locationResponseModel.value.work.last;
          }
          if (cont.locationResponseModel.value.others.isNotEmpty) {
            _otherAddress = cont.locationResponseModel.value.others.last;
          }

          return Column(
            children: [
              _homeAddress == null
                  ? customSavedAddressesWid("home".tr, "", 0,
                      editOnTap: () => () async {
                            await Get.to(
                              () => LocationScreen(
                                isSelectHomeAddress: true,
                                isSelectOtherAddress: false,
                              ),
                            );
                          })
                  : customSavedAddressesWid(
                      "home".tr, _homeAddress.address!, _homeAddress.id!,
                      editOnTap: () => () async {
                            await Get.to(
                              () => LocationScreen(
                                isSelectHomeAddress: true,
                                isSelectOtherAddress: false,
                              ),
                            );
                          }),
              _workAddress == null
                  ? customSavedAddressesWid("work".tr, "", 0,
                      editOnTap: () => () async {
                            await Get.to(
                              () => LocationScreen(
                                isSelectHomeAddress: false,
                                isSelectOtherAddress: false,
                              ),
                            );
                          })
                  : customSavedAddressesWid(
                      "work".tr, _workAddress.address!, _workAddress.id!,
                      editOnTap: () => () async {
                            await Get.to(
                              () => LocationScreen(
                                isSelectHomeAddress: false,
                                isSelectOtherAddress: false,
                              ),
                            );
                          }),
              _otherAddress == null ||
                      cont.locationResponseModel.value.others.isEmpty
                  ? customSavedAddressesWid("other".tr, "", 0,
                      editOnTap: () => () async {
                            await Get.to(
                              () => LocationScreen(
                                isSelectHomeAddress: false,
                                isSelectOtherAddress: true,
                              ),
                            );
                          })
                  : customSavedAddressesWid(
                      "other".tr, _otherAddress.address!, _otherAddress.id!,
                      editOnTap: () => () async {
                            await Get.to(
                              () => LocationScreen(
                                isSelectHomeAddress: false,
                                isSelectOtherAddress: true,
                              ),
                            );
                          }),
            ],
          );
        },
      ),
    );
  }

  Widget customSavedAddressesWid(String type, String add, int deleteId,
      {Function? editOnTap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(type,
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(add,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  await _showAddressDeleteDialog(addressId: deleteId);
                },
                child: Container(
                  width: 115,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Image.asset(AppImage.delete,
                      fit: BoxFit.contain, height: 25, width: 25),
                ),
              ),
              InkWell(
                onTap: editOnTap!.call(),
                child: Container(
                  width: 115,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Image.asset(AppImage.edit, color: AppColors.white,
                      fit: BoxFit.contain, height: 20, width: 20),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _showAddressDeleteDialog({int? addressId}) async {
    await Get.dialog(
      AddressDeleteDialog(
        addressId: addressId,
        deleteButton: () async {
          await _userController.deleteLocation(id: "${addressId ?? 0}");
          await _userController.getLocation();
        },
      ),
    );
  }
}
