import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/bookfor_someone_else.dart';
import 'package:arbyuser/ui/widget/custom_button.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class GiveFeedbackDialog extends StatefulWidget {
  const GiveFeedbackDialog({Key? key}) : super(key: key);

  @override
  State<GiveFeedbackDialog> createState() => _GiveFeedbackDialogState();
}

class _GiveFeedbackDialogState extends State<GiveFeedbackDialog> {
  final UserController _userController = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: CustomAppBar(text: "Give Feedback"),
        body: Form(
          key: _formKey,
          child: GetX<UserController>(
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
                      height: 75,
                      margin: EdgeInsets.symmetric(
                          horizontal: 25.w, vertical: 10),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r)),
                      child: TextFormField(
                        controller: cont.giveFeedbackTitleController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Title is required';
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
                          hintText: "Title",
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
                        controller: cont.giveFeedbackDescriptionController,
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
                        onTap: () {
                          setState(() {
                            isBookForSomeOne = false;
                          });
                          if (_formKey.currentState!.validate()) {
                            cont.givenFeedback(
                                cont.giveFeedbackTitleController.text,
                                cont.giveFeedbackDescriptionController.text);
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
