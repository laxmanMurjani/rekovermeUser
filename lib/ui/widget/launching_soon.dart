import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LaunchingSoon extends StatelessWidget {
  const LaunchingSoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(backgroundColor: Colors.white,
      appBar: CustomAppBar(
        text: "Road Side Service".tr,
      ),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 20,bottom: 15),child: Image.asset(AppImage.launching1),),
            Text('Launching Soon!',style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: Color(0xFF002744)),),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 20),child: Image.asset(AppImage.launching2),),
        
      ],),),
    );
  }
}
