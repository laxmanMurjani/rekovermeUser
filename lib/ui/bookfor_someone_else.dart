import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/promocode_list_model.dart';
import 'package:arbyuser/ui/widget/custom_button.dart';
import 'package:arbyuser/ui/widget/custom_text_filed.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arbyuser/util/app_constant.dart';

bool isBookForSomeOne = false;

class BookForSomeoneElse extends StatefulWidget {
  const BookForSomeoneElse({Key? key}) : super(key: key);

  @override
  State<BookForSomeoneElse> createState() => _BookForSomeoneElseState();
}

class _BookForSomeoneElseState extends State<BookForSomeoneElse> {
  final HomeController _homeController = Get.find();
  final UserController _userController = Get.find();

  Contact? _contacts;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickContact() async {
    try {
      final Contact? contact = await ContactsService.openDeviceContactPicker(
          iOSLocalizedLabels: true, androidLocalizedLabels: true);
      setState(() {
        _contacts = contact;
      });
    } catch (e) {
      print(e.toString());
    }
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
            backgroundColor: AppColors.white,
            appBar: CustomAppBar(
              text: "Book For Someone Else",
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child:
                      CustomButton(onTap: _pickContact, text: "Pick Contact"),
                ),
                _contacts == null
                    ? SizedBox()
                    : customSavedContactsWid(
                        _contacts!.displayName!,
                        _contacts!.phones!.isEmpty || _contacts!.phones == null
                            ? ""
                            : _contacts!.phones!.first.value!
                                .split("-")
                                .join()
                                .trim())
              ],
            ),
          ));
        },
      );
    });
  }

  Widget customSavedContactsWid(String contactName, String contactNo) {
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
            height: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(contactNo,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: CustomButton(
                onTap: () {
                  if (_contacts!.phones == null || _contacts!.phones!.isEmpty) {
                    Get.snackbar(
                        "Message", "Please check, your select number is empty",
                        backgroundColor: Colors.redAccent,
                        colorText: AppColors.white);
                  } else {
                    String number = _contacts!.phones!.first.value!
                        .split("-")
                        .join()
                        .split("+")
                        .join()
                        .split(" ")
                        .join()
                        .trim();
                    print("number ==> ${number.trim()}");
                    setState(() {
                      isBookForSomeOne = true;
                    });
                    _homeController.bookSomeNumber.value = number;
                    _homeController.bookSomeName.value =
                        _contacts!.displayName!;
                    print("number ==> ${_homeController.bookSomeName.value}");
                    Get.back();
                    Get.back();
                    // if (number.length == 12) {
                    //   _homeController.sendRequest(params: {
                    //     "else_mobile":
                    //         "+${_contacts!.phones!.isEmpty || _contacts!.phones == null ? "" : number}"
                    //   });
                    // } else {
                    //   _homeController.sendRequest(params: {
                    //     "else_mobile":
                    //         "+91${_contacts!.phones!.isEmpty || _contacts!.phones == null ? "" : number}"
                    //   });
                    // }
                    _homeController.isBookSomeOne.value = true;
                    Get.showSnackbar(GetSnackBar(
                      snackPosition: SnackPosition.TOP,
                      title: "Message",
                      message: "Contact Picked",
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ));
                  }
                },
                text: "Pick"),
          )
        ],
      ),
    );
  }
}
