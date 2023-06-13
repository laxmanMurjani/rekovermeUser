import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/database/database.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/promocode_list_model.dart';
import 'package:arbyuser/model/show_saved_contact_model.dart';
import 'package:arbyuser/ui/widget/custom_button.dart';
import 'package:arbyuser/ui/widget/custom_text_filed.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arbyuser/util/app_constant.dart';

class SavedContacts extends StatefulWidget {
  const SavedContacts({Key? key}) : super(key: key);

  @override
  State<SavedContacts> createState() => _SavedContactsState();
}

class _SavedContactsState extends State<SavedContacts> {
  final HomeController _homeController = Get.find();
  final UserController _userController = Get.find();

  // final dbHelper = DataBaseManager.instance;
  //
  // List<DataModel> taskList = [];

  Contact? _contacts;

  Future<void> _pickContact() async {
    try {
      final Contact? contact = await ContactsService.openDeviceContactPicker(
          iOSLocalizedLabels: true, androidLocalizedLabels: true);
      setState(() {
        _contacts = contact;
        _homeController.contactPickup.value = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<ShowSavedContactModel> getLiveMatchDetailsStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return _homeController.showSavedContact();
    }).asyncMap(
      (value) async => await value,
    );
  }

  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _homeController.showSavedContact();
    });

    // dbHelper.queryAllRows().then((value) {
    //   setState(() {
    //     value.forEach((element) {
    //       taskList.add(DataModel(
    //           contactName: element["columnContactName"],
    //           contactNumber: element["columnContactNumber"]));
    //     });
    //   });
    // }).catchError((error) {
    //   print(error);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(builder: (homeCont) {
      if (homeCont.error.value.errorType == ErrorType.internet) {
        return NoInternetWidget();
      }

      return GetX<UserController>(
        builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }

          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: CustomAppBar(
                text: "saved_contacts".tr,
              ),
              body: Stack(
                children: [
                  Container(
                    // alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        right: 25.0, left: 25.0, top: 25, bottom: 25),
                    child: Column(
                      children: [
                        _contacts == null
                            ? SizedBox()
                            : Text(
                                "Picked Number:- ${_contacts!.displayName}  ${_contacts!.phones![0].value}",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: CustomButton(
                            text: "pick_contact".tr,
                            onTap: () async {
                              _pickContact();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: CustomButton(
                            text: "save_contact".tr,
                            onTap: () async {
                              print("cccoo===> ${_contacts!.displayName}");
                              print("cccoo===> ${_contacts!.displayName}");
                              await homeCont.addSaveContactList(
                                  _contacts!.displayName == null
                                      ? ""
                                      : _contacts!.displayName!,
                                  _contacts!.phones == null ||
                                          _contacts!.phones!.isEmpty
                                      ? ""
                                      : _contacts!.phones![0].value!
                                          .split("-")
                                          .join());

                              print("complete save");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  homeCont.savedContactList.isEmpty
                      ? Center(
                          child: Text('No Data !!!'),
                        )
                      : StreamBuilder<ShowSavedContactModel>(
                          stream: getLiveMatchDetailsStream(),
                          builder: (context, snapshot) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.22),
                              child: ListView.builder(
                                  itemCount: homeCont.savedContactList.length,
                                  itemBuilder: (context, index) {
                                    return customSavedContactWid(
                                        homeCont.savedContactList[index].name!,
                                        homeCont
                                            .savedContactList[index].mobile!,
                                        () => () async {
                                              await homeCont
                                                  .deleteSaveContactList(
                                                      homeCont
                                                          .savedContactList[
                                                              index]
                                                          .id);
                                            },
                                        () => () async {
                                              _pickContact();
                                              print(
                                                  "_contacts!.displayName==> ${_contacts!.displayName}");
                                              // if(){
                                              //
                                              // }
                                              await homeCont
                                                  .editSaveContactList(
                                                      _contacts == null
                                                          ? ""
                                                          : _contacts!
                                                              .displayName,
                                                      _contacts == null
                                                          ? ""
                                                          : _contacts!.phones ==
                                                                      null ||
                                                                  _contacts!
                                                                      .phones!
                                                                      .isEmpty
                                                              ? ""
                                                              : _contacts!
                                                                  .phones![0]
                                                                  .value!
                                                                  .split("-")
                                                                  .join(),
                                                      homeCont
                                                          .savedContactList[
                                                              index]
                                                          .id);
                                            });
                                  }),
                            );
                          }),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget customSavedContactWid(String contactName, String contactNumber,
      Function deleteOnTap, Function editOnTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [AppBoxShadow.defaultShadow()]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(contactName,
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
            child: Text(contactNumber,
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
                onTap: deleteOnTap!.call(),
                child: Container(
                  width: 115,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F2F3),
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
                  child: Image.asset(AppImage.edit,
                      fit: BoxFit.contain, height: 20, width: 20),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
