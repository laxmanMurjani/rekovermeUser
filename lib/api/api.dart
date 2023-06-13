import 'dart:io';

class ApiUrl {
  static const String _baseUrl = 'https://demo.mozilit.com/superAdminLogin/Recuvame_taxi/public/';
      //'https://demo.mozilit.com/superAdminLogin/arby/public';
  // static const String _baseUrl = 'https://demo.mozilit.com/superAdminLogin/eto_taxi/public';
  static const String baseImageUrl = _baseUrl;
  static const String BASE_URL = _baseUrl;
  static const String termsCondition = "${BASE_URL}/terms";
  static const String privacyPolicy = "${BASE_URL}/terms";

  static const String apiBaseUrl = '$_baseUrl/api/user';

  static const String clientId = "4";
  static const String clientSecret = "BCqFFBEceWF5wRNzMIbh6AtkD0uJy5heEwusovh0";

  // static const String clientId = "5";
  // static const String clientSecret = "Fg7SAg4540H9dQ0WagKh49Lg9QL1q2JLPowN4bfe";

  static String deviceType = Platform.isAndroid ? "android" : "ios";

  static String signUp = "$apiBaseUrl/signup";
  static String login = "$apiBaseUrl/oauth/token";
  static String googleLogin = "$apiBaseUrl/auth/google";
  static String facebookLogin = "$apiBaseUrl/auth/facebook";
  static String appleLogin = "$apiBaseUrl/auth/apple";
  static String userDetails = "$apiBaseUrl/details";
  static String services = "$apiBaseUrl/services";
  static String fare = "$apiBaseUrl/estimated/fare";
  static String request = "$apiBaseUrl/send/request";
  static String paymentMode = "$apiBaseUrl/change-payment-mod";
  static String requestCheck = "$apiBaseUrl/request/check";
  static String requestCancel = "$apiBaseUrl/cancel/request";
  static String promoCodesList = "$apiBaseUrl/promocodes_list";
  static String providerRate = "$apiBaseUrl/rate/provider";
  static String etoRate = "$apiBaseUrl/rate/eto";
  static String trips = "$apiBaseUrl/trips";
  static String tripDetails = "$apiBaseUrl/trip/details";
  static String upcomingTrips = "$apiBaseUrl/upcoming/trips";
  static String upcomingTripDetails = "$apiBaseUrl/upcoming/trip/details";
  static String notifications = "$apiBaseUrl/notifications/user";
  static String passBook = "$apiBaseUrl/wallet/passbook";
  static String reasons = "$apiBaseUrl/reasons";
  static String updateProfile = "$apiBaseUrl/update/profile";
  static String sendOTPProfile = "$apiBaseUrl/sendotp_profile";
  static String verifyOTPProfile = "$apiBaseUrl/otp_verified_for_profile_update";
  static String changePassword = "$apiBaseUrl/change/password";
  static String help = "$apiBaseUrl/help";
  static String location = "$apiBaseUrl/location";
  static String logout = "$apiBaseUrl/logout";
  static String chat = "$apiBaseUrl/chat";
  static String disputeList = "$apiBaseUrl/dispute-list";
  static String dispute = "$apiBaseUrl/dispute";
  static String dropItem = "$apiBaseUrl/drop-item";
  static String sendOtp = "$apiBaseUrl/sendotp";
  static String sendOtpWithAuth = "$apiBaseUrl/signup/otp";
  static String verifyOtpWithAuth = "$apiBaseUrl/verify/otp";
  static String verifyOTP = "$apiBaseUrl/otp_verified";
  static String forgotPassword = "$apiBaseUrl/forgot/password";
  static String resetPassword = "$apiBaseUrl/reset/password";
  static String cardList = "$apiBaseUrl/cardList";
  static String createCard = "$apiBaseUrl/createCard";
  static String walletAdd = "$apiBaseUrl/walletAdd";
  static String updateRequest = "$apiBaseUrl/update/request";
  static String extendTrip = "$apiBaseUrl/extend/trip";
  static String payment = "$apiBaseUrl/payment";
  static String deleteAccount = "$apiBaseUrl/delete/account";
  static String showContact = "$apiBaseUrl/show/contact";
  static String showProviders = "$apiBaseUrl/show/providers";
  static String showNearByDriver = "$apiBaseUrl/show_driver_emt";
  static String addSaveContactList = "$apiBaseUrl/add_contact";
  static String editSaveContactList = "$apiBaseUrl/edit/contact";
  static String deleteSaveContactList = "$apiBaseUrl/delete/contact";
  static String giveFeedback = "$apiBaseUrl/ticketcreate";

  static String payStackUrl(
          {required String email,
          required dynamic userId,
          required dynamic amount,
          String paymentMode = "PAYSTACK",
          String? requestId,
          String userType = "user"}) =>
      "${_baseUrl}/getform?email=$email&amount=$amount&payment_mode=$paymentMode&user_id=$userId&user_type=$userType ${requestId != null ? "&user_request_id=$requestId" : ""}";
}
