import 'dart:io';

import 'package:flutter/material.dart';
import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/controller/base_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: CustomAppBar(
        //   text: "terms_and_Condition".tr,
        // ),
        body: WebView(
          initialUrl: ApiUrl.privacyPolicy,
          onPageFinished: (s) {
            _baseController.dismissLoader();
          },
        ),
      ),
    );
  }
}
