import 'dart:io';

import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/controller/base_controller.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  final BaseController _baseController = BaseController();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _baseController.showLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        text: "terms_condition".tr,
      ),
      body: WebView(
        initialUrl: ApiUrl.termsCondition,
        onPageFinished: (s) {
          _baseController.dismissLoader();
        },
      ),
    );
  }
}
