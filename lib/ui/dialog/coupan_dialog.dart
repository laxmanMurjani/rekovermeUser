import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/promocode_list_model.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


bool isSelectedCoupon = false;

class CoupanDialog extends StatefulWidget {
  const CoupanDialog({Key? key}) : super(key: key);

  @override
  State<CoupanDialog> createState() => _CoupanDialogState();
}

class _CoupanDialogState extends State<CoupanDialog> {
  final HomeController _homeController = Get.find();
  final UserController _userController = Get.find();
  final PageController _pageController = PageController(initialPage: 0);
  int _pageSelected = 0;
  final DateFormat _dateFormat = DateFormat("dd,MMMM yyyy");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getPromoCodeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        if (cont.promoCodeList.isEmpty) {
          return Container(
            width: double.infinity,
            height: 155.h,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              "no_data_found..".tr,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5.h),
                height: 230.h,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25))),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: PageView.builder(
                          controller: _pageController,
                          itemBuilder: (context, index) {
                            PromoList promoModel = cont.promoCodeList[index];
                            bool isSelected =
                                _homeController.selectedPromoCode?.id ==
                                    promoModel.id;
                            return Container(
                              height: 240,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
                                  )),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 30),
                              child: Column(
                                children: [
                                  Container(
                                    // height: 200,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${promoModel.promoCode ?? ""}".tr,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17),
                                        ),
                                        SizedBox(height: 10.h),
                                        Divider(
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                        SizedBox(height: 10.h),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${promoModel.promoDescription ?? ""}"
                                                        .tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    "Valid till: ${_dateFormat.format(promoModel.expiration ?? DateTime.now())}"
                                                        .tr,
                                                    style: TextStyle(
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (isSelected) {
                                                    setState(() {
                                                      isSelectedCoupon = false;
                                                    });
                                                    _homeController
                                                            .selectedPromoCode =
                                                        null;
                                                  } else {
                                                    setState(() {
                                                      isSelectedCoupon = true;
                                                    });
                                                    _homeController
                                                            .selectedPromoCode =
                                                        promoModel;

                                                    print("check snackbar");
                                                  }
                                                  setState(() {});
                                                  Get.back();
                                                },
                                                child: Text(isSelected
                                                    ? "remove".tr
                                                    : "use_code".tr,style: TextStyle(fontSize: 12,
                                                overflow: TextOverflow.ellipsis),),
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      // Change your radius here
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  7)),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onPageChanged: (value) {
                            print(value);
                            setState(() {
                              _pageSelected = value;
                            });
                          },
                          itemCount: cont.promoCodeList.length,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cont.promoCodeList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            height: 9.w,
                            width: 9.w,
                            decoration: BoxDecoration(
                              color: _pageSelected == index
                                  ? Colors.black
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 35.h)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
