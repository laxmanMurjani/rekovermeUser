import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static loginUpdateToken(String? userID) async {
    await FirebaseMessaging.instance.getToken().then((value) {
      log("tocken===> $value");
      // newGenerateToken = value!;
    });
    // print("newGenerateToken:- ${newGenerateToken}");
    // await FirebaseFirestore.instance
    //     .collection('${userDetail}')
    //     .doc(userID)
    //     .update({'${fcmToken}': newGenerateToken})
    //     .then((value) => print("${userUpdated}"))
    //     .catchError((error) =>
    //     print("Failed to update user: $error"));
  }
}
