import 'dart:io';

import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/change_password_sceen.dart';
import 'package:arbyuser/ui/dialog/account_delete_dialog.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController _userController = Get.find();
  final ImagePicker _imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();

    // _userController.imageFilePah = null;
    _userController.firstNameController.text =
        _userController.userData.value.firstName ?? "";
    _userController.lastNameController.text =
        _userController.userData.value.lastName ?? "";
    _userController.phoneNumberController.text =
        _userController.userData.value.mobile ?? "";
    _userController.emailController.text =
        _userController.userData.value.email ?? "";
    print("_userController.firstNameController.text====>${_userController.firstNameController.text}");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(text: "profile".tr),
        body: GetX<UserController>(
          builder: (cont) {
            if (cont.error.value.errorType == ErrorType.internet) {
              return NoInternetWidget();
            }
            String? profileUrl;
            if (cont.userData.value.picture != null) {
              profileUrl =
              "${ApiUrl.baseImageUrl}${cont.userData.value.picture ?? ""}";
              print("obtsss====>${"${ApiUrl.baseImageUrl}${cont.userData.value.picture ?? ""}"}");
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Choose option",
                                style: TextStyle(color: Colors.blue),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Divider(
                                      height: 1,
                                      color: Colors.blue,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Get.back();
                                        _imagePick();
                                      },
                                      title: Text("Gallery"),
                                      leading: Icon(
                                        Icons.account_box,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Colors.blue,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Get.back();
                                        _photoPick();
                                      },
                                      title: Text("Camera"),
                                      leading: Icon(
                                        Icons.camera,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.elliptical(120, 75)),
                      child:profileUrl == null ? Image.asset(AppImage.profilePic) :
                      CustomFadeInImage(
                        height: 196.w,
                        width: 185.w,
                        url:
                        "${cont.imageFilePah ?? profileUrl}",
                        placeHolder: AppImage.icUserPlaceholder,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  customAppTextFieldWidget(cont.firstNameController,
                      "first_name".tr, "first_name".tr),
                  customAppTextFieldWidget(
                      cont.lastNameController, "last_name".tr, "last_name".tr),
                  customAppTextFieldWidget(
                      cont.emailController,
                      "email".tr,
                      "email".tr,readOnly: true
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Container(
                              height: 55,
                              width: 110,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.white,
                                  boxShadow: [AppBoxShadow.defaultShadow()]),
                              child: Row(
                                children: [
                                  CountryCodePicker(
                                    onChanged: (s) {},
                                    textStyle: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    hideMainText: true,
                                    initialSelection:
                                    cont.userData.value.countryCode ??
                                        "+91",
                                    // favorite: ['+91', 'IN'],
                                    // countryFilter: ['IT', 'FR', "IN"],
                                    showFlagDialog: true,

                                    comparator: (a, b) =>
                                        b.name!.compareTo(a.name.toString()),
                                    //Get the country information relevant to the initial selection
                                    onInit: (code) => print(
                                        "on init ${code!.name} ${code.dialCode} ${code.name}"),
                                  ),
                                  Image.asset(
                                    AppImage.down_arrow,
                                    height: 15,
                                    width: 15,
                                    fit: BoxFit.contain,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 55,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.white,
                                  boxShadow: [AppBoxShadow.defaultShadow()]),
                              child: TextField(
                                controller: cont.phoneNumberController,
                                // readOnly: true,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                    isDense:true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(19),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(19),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 5.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(19),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 3.0),
                                    ),
                                    filled: true,
                                    hintStyle: TextStyle(
                                        color: AppColors.primaryColor,
                                        height: 1),
                                    hintText: "Phone Number".tr,
                                    fillColor: AppColors.white),
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500),
                                // textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => ChangePasswordScreen());
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 65,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Color(0xFFF1F2F3),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(50))),
                          child: Text("change_password".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.dialog(
                            AccountDeleteDialog(),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 65,
                          width: 150,
                          decoration: BoxDecoration(
                              color: AppColors.skyBlue,
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(50))),
                          child: Text("delete_account".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  InkWell(
                    onTap: () {

                      if(_userController.userData.value.mobile!.contains(cont.phoneNumberController.text)){
                        print("same");
                        cont.updateProfile();
                      } else {

                        print("other");
                        cont.sendProfileOtp();
                      }



                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 45),
                      alignment: Alignment.center,
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.skyBlue,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Text("save".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _imagePick() async {
    final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 10);
    if (image != null) {
      _userController.imageFilePah = image.path;
      print("checkImagePath===>${_userController.imageFilePah}");
      setState(() {});
    }
  }

  Future<void> _photoPick() async {
    _userController.removeUnFocusManager();

    final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 10);
    if (image != null) {
      _userController.imageFilePah = image.path;
      setState(() {});
    }
  }

  Widget customAppTextFieldWidget(
      TextEditingController controller, String hintText, String titleText,{bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19.0),
              boxShadow: [AppBoxShadow.defaultShadow()],
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              scrollPadding: EdgeInsets.symmetric(horizontal: 10),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(19),
                    borderSide: BorderSide(color: Colors.white, width: 5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(19),
                    borderSide: BorderSide(color: Colors.white, width: 3.0),
                  ),
                  filled: true,isDense: true,
                  hintStyle: TextStyle(color: AppColors.white, height: 1),
                  hintText: hintText.tr,
                  fillColor: AppColors.white),
              style: TextStyle(color: AppColors.primaryColor),
              // textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
