import 'dart:convert';
import 'dart:developer';
import 'package:arbyuser/model/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails {

  Future<void> saveUserDetails(LoginResponseModel userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("user", jsonEncode(userModel.toJson()));
  }

  Future<void> logoutUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("user");
  }

  Future<LoginResponseModel> get getSaveUserDetails async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString("user");
    log("message  ==>  $userData");
    if (userData == null) {
      return LoginResponseModel();
    }
    return loginResponseModelFromJson(userData);
  }

  Future<void> saveTutorialShow({bool isTutorialShow = false}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isTutorialShow", isTutorialShow);
  }

  Future<bool> get isTutorialShow async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("isTutorialShow") ?? false;
  }
}
