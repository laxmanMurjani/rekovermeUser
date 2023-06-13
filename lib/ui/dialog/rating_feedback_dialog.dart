import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/Locationscreen.dart';
import 'package:arbyuser/ui/home_screen.dart';
import 'package:arbyuser/ui/widget/custom_button.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingFeedbackDialog extends StatefulWidget {
  int? rating;

  RatingFeedbackDialog({this.rating});

  @override
  State<RatingFeedbackDialog> createState() => _RatingFeedbackDialogState();
}

class _RatingFeedbackDialogState extends State<RatingFeedbackDialog> {
  final UserController _userController = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: CustomAppBar(text: "Rating feedback for driver"),
        body: Form(
          key: _formKey,
          child: GetX<HomeController>(builder: (homeCont) {
            if (homeCont.error.value.errorType == ErrorType.internet) {
              return NoInternetWidget();
            }
            return GetX<UserController>(
              builder: (cont) {
                if (cont.error.value.errorType == ErrorType.internet) {
                  return NoInternetWidget();
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 200,
                        margin: EdgeInsets.symmetric(
                            horizontal: 25.w, vertical: 10),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r)),
                        child: TextFormField(
                          maxLines: 20,
                          controller: cont.driverFeedbackController,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 25),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "Description",
                            hintStyle: TextStyle(
                                fontSize: 18,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: CustomButton(
                          text: "Submit",
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              String? msg = await homeCont.providerRate(
                                  rating: "${widget.rating!.toInt()}",
                                  comment:
                                      cont.driverFeedbackController.text);
                              print("messsagdddddde===> $msg");
                              print(
                                  "isDriverShowisDriverShow===>${isDriverShow}");

                              homeCont.driverRating.value = true;
                              // Get.back();

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                  (route) => false);

                              setState(() {
                                isDriverShow = true;
                              });
                           Future.delayed(Duration(seconds: 2),() {
                             Get.showSnackbar(GetSnackBar(
                               backgroundColor: Colors.green,
                               message: "Message",
                               title: "User Rated successfully!",
                               snackPosition: SnackPosition.TOP,
                               duration: Duration(seconds: 2),
                             ));
                           },);
                              await homeCont.getDriverMarkerData(
                                  updateData: () => setState(() {}));

                            }

                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
