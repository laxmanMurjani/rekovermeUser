import 'dart:convert';

CheckRequestResponseModel checkRequestResponseModelFromJson(String str) =>
    CheckRequestResponseModel.fromJson(json.decode(str));

String checkRequestResponseModelToJson(CheckRequestResponseModel data) =>
    json.encode(data.toJson());

class CheckRequestResponseModel {
  CheckRequestResponseModel({
    this.data = const [],
    this.checkBreakDown_status,
    this.multiDestination = const [],
    this.fadeedback_count,
    this.feedback_check,
    this.driver_device_token,
    this.sos,
    this.cash,
    this.card,
    this.currency,
    this.payumoney,
    this.paypal,
    this.paypalAdaptive,
    this.braintree,
    this.paytm,
    this.stripeSecretKey,
    this.stripePublishableKey,
    this.stripeCurrency,
    this.payumoneyEnvironment,
    this.payumoneyKey,
    this.payumoneySalt,
    this.payumoneyAuth,
    this.paypalEnvironment,
    this.paypalCurrency,
    this.paypalClientId,
    this.paypalClientSecret,
    this.braintreeEnvironment,
    this.braintreeMerchantId,
    this.braintreePublicKey,
    this.braintreePrivateKey,
    this.provider_select_timeout,
  });

  List<Datum> data;
  List<MultiDestination> multiDestination;
  String? sos;
  String? checkBreakDown_status;
  int? fadeedback_count;
  String? driver_device_token;
  int? feedback_check;
  dynamic cash;
  dynamic card;
  dynamic provider_select_timeout;
  String? currency;
  dynamic payumoney;
  dynamic paypal;
  dynamic paypalAdaptive;
  dynamic braintree;
  dynamic paytm;
  String? stripeSecretKey;
  String? stripePublishableKey;
  String? stripeCurrency;
  String? payumoneyEnvironment;
  String? payumoneyKey;
  String? payumoneySalt;
  String? payumoneyAuth;
  String? paypalEnvironment;
  String? paypalCurrency;
  String? paypalClientId;
  String? paypalClientSecret;
  String? braintreeEnvironment;
  String? braintreeMerchantId;
  String? braintreePublicKey;
  String? braintreePrivateKey;

  factory CheckRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      CheckRequestResponseModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        multiDestination: json["multi_destination"] == null
            ? []
            : List<MultiDestination>.from(json["multi_destination"]
                .map((x) => MultiDestination.fromJson(x))),
        sos: json["sos"],
        checkBreakDown_status: json["checkBreakDown_status"],
        cash: json["cash"],
        fadeedback_count: json["fadeedback_count"],
        feedback_check: json["feedback_check"],
        driver_device_token: json["driver_device_token"],
        card: json["card"],
        currency: json["currency"],
        payumoney: json["payumoney"],
        paypal: json["paypal"],
        paypalAdaptive: json["paypal_adaptive"],
        braintree: json["braintree"],
        paytm: json["paytm"],
        stripeSecretKey: json["stripe_secret_key"],
        stripePublishableKey: json["stripe_publishable_key"],
        stripeCurrency: json["stripe_currency"],
        payumoneyEnvironment: json["payumoney_environment"],
        payumoneyKey: json["payumoney_key"],
        payumoneySalt: json["payumoney_salt"],
        payumoneyAuth: json["payumoney_auth"],
        paypalEnvironment: json["paypal_environment"],
        paypalCurrency: json["paypal_currency"],
        paypalClientId: json["paypal_client_id"],
        paypalClientSecret: json["paypal_client_secret"],
        braintreeEnvironment: json["braintree_environment"],
        braintreeMerchantId: json["braintree_merchant_id"],
        braintreePublicKey: json["braintree_public_key"],
        braintreePrivateKey: json["braintree_private_key"],
        provider_select_timeout: json["provider_select_timeout"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "multi_destination":
            List<dynamic>.from(multiDestination.map((x) => x.toJson())),
        "sos": sos,
        "checkBreakDown_status": checkBreakDown_status,
        "fadeedback_count": fadeedback_count,
        "driver_device_token": driver_device_token,
        "feedback_check": feedback_check,
        "cash": cash,
        "card": card,
        "currency": currency,
        "payumoney": payumoney,
        "paypal": paypal,
        "paypal_adaptive": paypalAdaptive,
        "braintree": braintree,
        "paytm": paytm,
        "stripe_secret_key": stripeSecretKey,
        "stripe_publishable_key": stripePublishableKey,
        "stripe_currency": stripeCurrency,
        "payumoney_environment": payumoneyEnvironment,
        "payumoney_key": payumoneyKey,
        "payumoney_salt": payumoneySalt,
        "payumoney_auth": payumoneyAuth,
        "paypal_environment": paypalEnvironment,
        "paypal_currency": paypalCurrency,
        "paypal_client_id": paypalClientId,
        "paypal_client_secret": paypalClientSecret,
        "braintree_environment": braintreeEnvironment,
        "braintree_merchant_id": braintreeMerchantId,
        "braintree_public_key": braintreePublicKey,
        "braintree_private_key": braintreePrivateKey,
        "provider_select_timeout": provider_select_timeout,
      };
}

class Datum {
  Datum({
    this.id,
    this.bookingId,
    this.userId,
    this.braintreeNonce,
    this.providerId,
    this.currentProviderId,
    this.serviceTypeId,
    this.promocodeId,
    this.rentalHours,
    this.status,
    this.cancelledBy,
    this.cancelReason,
    this.paymentMode,
    this.selected_payment,
    this.paid,
    this.isTrack,
    this.distance,
    this.travelTime,
    this.unit,
    this.otp,
    this.sAddress,
    this.sLatitude,
    this.sLongitude,
    this.dAddress,
    this.dLatitude,
    this.dLongitude,
    this.trackDistance,
    this.trackLatitude,
    this.trackLongitude,
    this.destinationLog,
    this.isDropLocation,
    this.isInstantRide,
    this.isDispute,
    this.assignedAt,
    this.scheduleAt,
    this.startedAt,
    this.finishedAt,
    this.isScheduled,
    this.userRated,
    this.providerRated,
    this.useWallet,
    this.surge,
    this.routeKey,
    this.nonce,
    this.geoFencingId,
    this.geoFencingDistance,
    this.geoTime,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.fare,
    this.isManual,
    this.breakdown,
    this.bkd_for_reqid,
    this.user,
    this.provider,
    this.serviceType,
    this.providerService,
    this.rating,
    this.payment,
    this.rideOtp,
    this.reasons = const [],
  });

  dynamic id;
  String? bookingId;
  dynamic userId;
  dynamic braintreeNonce;
  dynamic providerId;
  dynamic currentProviderId;
  dynamic serviceTypeId;
  dynamic promocodeId;
  dynamic rentalHours;
  StatusType? status;
  String? cancelledBy;
  dynamic cancelReason;
  String? paymentMode;
  dynamic paid;
  dynamic bkd_for_reqid;
  String? isTrack;
  double? distance;
  String? travelTime;
  String? selected_payment;
  String? unit;
  String? otp;
  String? sAddress;
  double? sLatitude;
  double? sLongitude;
  String? dAddress;
  double? dLatitude;
  double? dLongitude;
  dynamic trackDistance;
  dynamic trackLatitude;
  dynamic trackLongitude;
  String? destinationLog;
  dynamic isDropLocation;
  dynamic isInstantRide;
  dynamic isDispute;
  DateTime? assignedAt;
  dynamic scheduleAt;
  dynamic startedAt;
  dynamic finishedAt;
  String? isScheduled;
  dynamic userRated;
  dynamic providerRated;
  dynamic useWallet;
  dynamic surge;
  String? routeKey;
  dynamic nonce;
  dynamic geoFencingId;
  dynamic geoFencingDistance;
  String? geoTime;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fare;
  dynamic isManual;
  dynamic breakdown;
  User? user;
  Provider? provider;
  ServiceType? serviceType;
  ProviderService? providerService;
  dynamic rating;
  Payment? payment;
  dynamic rideOtp;
  List<Reason> reasons;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        bookingId: json["booking_id"],
        userId: json["user_id"],
        braintreeNonce: json["braintree_nonce"],
        providerId: json["provider_id"],
        currentProviderId: json["current_provider_id"],
        serviceTypeId: json["service_type_id"],
        promocodeId: json["promocode_id"],
        rentalHours: json["rental_hours"],
        status: statusTypeValues.map[json["status"]],
        cancelledBy: json["cancelled_by"],
        cancelReason: json["cancel_reason"],
        paymentMode: json["payment_mode"],
    selected_payment: json["selected_payment"],
        paid: json["paid"],
        isTrack: json["is_track"],
        distance: json["distance"].toDouble(),
        travelTime: json["travel_time"],
        unit: json["unit"],
        otp: json["otp"],
        sAddress: json["s_address"],
        sLatitude: json["s_latitude"].toDouble(),
        sLongitude: json["s_longitude"].toDouble(),
        dAddress: json["d_address"],
        dLatitude: json["d_latitude"].toDouble(),
        dLongitude: json["d_longitude"].toDouble(),
        trackDistance: json["track_distance"],
        trackLatitude: json["track_latitude"],
        trackLongitude: json["track_longitude"],
        destinationLog: json["destination_log"],
        isDropLocation: json["is_drop_location"],
        isInstantRide: json["is_instant_ride"],
        isDispute: json["is_dispute"],
        assignedAt: DateTime.parse(json["assigned_at"]),
        scheduleAt: json["schedule_at"],
        startedAt: json["started_at"],
        finishedAt: json["finished_at"],
        isScheduled: json["is_scheduled"],
        userRated: json["user_rated"],
        providerRated: json["provider_rated"],
        useWallet: json["use_wallet"],
        surge: json["surge"],
        routeKey: json["route_key"],
        nonce: json["nonce"],
        geoFencingId: json["geo_fencing_id"],
        geoFencingDistance: json["geo_fencing_distance"],
        geoTime: json["geo_time"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        fare: json["fare"],
        isManual: json["is_manual"],
    breakdown: json["breakdown"],
    bkd_for_reqid: json["bkd_for_reqid"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        provider: json["provider"] == null
            ? null
            : Provider.fromJson(json["provider"]),
        serviceType: json["service_type"] == null
            ? null
            : ServiceType.fromJson(json["service_type"]),
        providerService: json["provider_service"] == null
            ? null
            : ProviderService.fromJson(json["provider_service"]),
        rating: json["rating"],
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        rideOtp: json["ride_otp"],
        reasons: json["reasons"] == null
            ? []
            : List<Reason>.from(json["reasons"].map((x) => Reason.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "user_id": userId,
        "braintree_nonce": braintreeNonce,
        "provider_id": providerId,
        "bkd_for_reqid": bkd_for_reqid,
        "current_provider_id": currentProviderId,
        "service_type_id": serviceTypeId,
        "promocode_id": promocodeId,
        "rental_hours": rentalHours,
        "status": statusTypeValues.reverse[status],
        "cancelled_by": cancelledBy,
        "cancel_reason": cancelReason,
        "payment_mode": paymentMode,
        "paid": paid,
        "is_track": isTrack,
        "distance": distance,
        "travel_time": travelTime,
        "unit": unit,
        "otp": otp,
        "s_address": sAddress,
        "s_latitude": sLatitude,
        "s_longitude": sLongitude,
        "d_address": dAddress,
        "d_latitude": dLatitude,
        "d_longitude": dLongitude,
        "track_distance": trackDistance,
        "track_latitude": trackLatitude,
        "track_longitude": trackLongitude,
        "destination_log": destinationLog,
        "is_drop_location": isDropLocation,
        "is_instant_ride": isInstantRide,
        "is_dispute": isDispute,
        "assigned_at": assignedAt?.toIso8601String(),
        "schedule_at": scheduleAt,
        "started_at": startedAt,
        "finished_at": finishedAt,
        "is_scheduled": isScheduled,
        "user_rated": userRated,
        "provider_rated": providerRated,
        "use_wallet": useWallet,
        "surge": surge,
        "route_key": routeKey,
        "nonce": nonce,
        "geo_fencing_id": geoFencingId,
        "geo_fencing_distance": geoFencingDistance,
        "geo_time": geoTime,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "fare": fare,
        "is_manual": isManual,
        "breakdown": breakdown,
        "user": user?.toJson(),
        "provider": provider?.toJson(),
        "service_type": serviceType?.toJson(),
        "provider_service": providerService?.toJson(),
        "rating": rating,
        "selected_payment": selected_payment,
        "payment": payment?.toJson(),
        "ride_otp": rideOtp,
        "reasons": List<dynamic>.from(reasons.map((x) => x.toJson())),
      };
}

enum StatusType {
  EMPTY,
  STARTED,
  ARRIVED,
  PICKEDUP,
  DROPPED,
  COMPLETED,
  RATING
}

final statusTypeValues = EnumValues({
  "EMPTY": StatusType.EMPTY,
  "STARTED": StatusType.STARTED,
  "ARRIVED": StatusType.ARRIVED,
  "PICKEDUP": StatusType.PICKEDUP,
  "DROPPED": StatusType.DROPPED,
  "COMPLETED": StatusType.COMPLETED,
  "RATING": StatusType.RATING,
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap = {};

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class Payment {
  Payment({
    this.id,
    this.requestId,
    this.userId,
    this.providerId,
    this.fleetId,
    this.promocodeId,
    this.paymentId,
    this.paymentMode,
    this.fixed,
    this.distance,
    this.minute,
    this.hour,
    this.commision,
    this.commisionPer,
    this.fleet,
    this.fleetPer,
    this.discount,
    this.discountPer,
    this.tax,
    this.taxPer,
    this.wallet,
    this.isPartial,
    this.cash,
    this.card,
    this.online,
    this.surge,
    this.tollCharge,
    this.roundOf,
    this.peakAmount,
    this.peakCommAmount,
    this.totalWaitingTime,
    this.waitingAmount,
    this.waitingCommAmount,
    this.tips,
    this.breakdown_amount,
    this.total,
    this.payable,
    this.providerCommission,
    this.providerPay,
  });

  int? id;
  int? requestId;
  int? userId;
  int? providerId;
  int? fleetId;
  dynamic promocodeId;
  dynamic paymentId;
  dynamic paymentMode;
  double? fixed;
  double? distance;
  int? minute;
  int? hour;
  dynamic commision;
  dynamic commisionPer;
  dynamic fleet;
  dynamic fleetPer;
  dynamic discount;
  dynamic discountPer;
  dynamic tax;
  dynamic taxPer;
  dynamic wallet;
  dynamic isPartial;
  dynamic cash;
  int? card;
  int? online;
  int? surge;
  dynamic tollCharge;
  double? roundOf;
  dynamic breakdown_amount;
  dynamic peakAmount;
  dynamic peakCommAmount;
  dynamic totalWaitingTime;
  dynamic waitingAmount;
  dynamic waitingCommAmount;
  dynamic tips;
  dynamic total;
  dynamic payable;
  dynamic providerCommission;
  double? providerPay;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        requestId: json["request_id"],
        userId: json["user_id"],
        providerId: json["provider_id"],
        fleetId: json["fleet_id"],
        promocodeId: json["promocode_id"],
        paymentId: json["payment_id"],
        paymentMode: json["payment_mode"],
        fixed: json["fixed"].toDouble(),
        distance: json["distance"].toDouble(),
        minute: json["minute"],
        hour: json["hour"],
        commision: json["commision"].toDouble(),
        commisionPer: json["commision_per"],
        fleet: json["fleet"],
        fleetPer: json["fleet_per"],
    breakdown_amount: json["breakdown_amount"],
        discount: json["discount"],
        discountPer: json["discount_per"],
        tax: json["tax"].toDouble(),
        taxPer: json["tax_per"],
        wallet: json["wallet"],
        isPartial: json["is_partial"],
        cash: json["cash"],
        card: json["card"],
        online: json["online"],
        surge: json["surge"],
        tollCharge: json["toll_charge"],
        roundOf: json["round_of"].toDouble(),
        peakAmount: json["peak_amount"],
        peakCommAmount: json["peak_comm_amount"],
        totalWaitingTime: json["total_waiting_time"],
        waitingAmount: json["waiting_amount"],
        waitingCommAmount: json["waiting_comm_amount"],
        tips: json["tips"],
        total: json["total"].toDouble(),
        payable: json["payable"],
        providerCommission: json["provider_commission"],
        providerPay: json["provider_pay"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_id": requestId,
        "user_id": userId,
        "provider_id": providerId,
        "fleet_id": fleetId,
        "promocode_id": promocodeId,
        "payment_id": paymentId,
        "payment_mode": paymentMode,
        "fixed": fixed,
        "distance": distance,
        "minute": minute,
        "hour": hour,
        "commision": commision,
        "commision_per": commisionPer,
        "fleet": fleet,
        "fleet_per": fleetPer,
        "breakdown_amount": breakdown_amount,
        "discount": discount,
        "discount_per": discountPer,
        "tax": tax,
        "tax_per": taxPer,
        "wallet": wallet,
        "is_partial": isPartial,
        "cash": cash,
        "card": card,
        "online": online,
        "surge": surge,
        "toll_charge": tollCharge,
        "round_of": roundOf,
        "peak_amount": peakAmount,
        "peak_comm_amount": peakCommAmount,
        "total_waiting_time": totalWaitingTime,
        "waiting_amount": waitingAmount,
        "waiting_comm_amount": waitingCommAmount,
        "tips": tips,
        "total": total,
        "payable": payable,
        "provider_commission": providerCommission,
        "provider_pay": providerPay,
      };
}

class Reason {
  Reason({
    this.id,
    this.type,
    this.reason,
    this.status,
  });

  dynamic id;
  String? type;
  String? reason;
  dynamic status;

  factory Reason.fromJson(Map<String, dynamic> json) => Reason(
        id: json["id"],
        type: json["type"],
        reason: json["reason"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "reason": reason,
        "status": status,
      };
}

class ServiceType {
  ServiceType({
    this.id,
    this.name,
    this.providerName,
    this.image,
    this.marker,
    this.capacity,
    this.fixed,
    this.price,
    this.minute,
    this.hour,
    this.distance,
    this.calculator,
    this.description,
    this.waitingFreeMins,
    this.waitingMinCharge,
    this.status,
  });

  dynamic id;
  String? name;
  String? providerName;
  String? image;
  String? marker;
  dynamic capacity;
  dynamic fixed;
  dynamic price;
  dynamic minute;
  dynamic hour;
  dynamic distance;
  String? calculator;
  dynamic description;
  dynamic waitingFreeMins;
  dynamic waitingMinCharge;
  dynamic status;

  factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
        id: json["id"],
        name: json["name"],
        providerName: json["provider_name"],
        image: json["image"],
        marker: json["marker"],
        capacity: json["capacity"],
        fixed: json["fixed"],
        price: json["price"],
        minute: json["minute"],
        hour: json["hour"],
        distance: json["distance"],
        calculator: json["calculator"],
        description: json["description"],
        waitingFreeMins: json["waiting_free_mins"],
        waitingMinCharge: json["waiting_min_charge"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "provider_name": providerName,
        "image": image,
        "marker": marker,
        "capacity": capacity,
        "fixed": fixed,
        "price": price,
        "minute": minute,
        "hour": hour,
        "distance": distance,
        "calculator": calculator,
        "description": description,
        "waiting_free_mins": waitingFreeMins,
        "waiting_min_charge": waitingMinCharge,
        "status": status,
      };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.paymentMode,
    this.userType,
    this.email,
    this.gender,
    this.countryCode,
    this.mobile,
    this.picture,
    this.deviceToken,
    this.deviceId,
    this.deviceType,
    this.loginBy,
    this.socialUniqueId,
    this.latitude,
    this.longitude,
    this.stripeCustId,
    this.walletBalance,
    this.rating,
    this.otp,
    this.language,
    this.qrcodeUrl,
    this.referralUniqueId,
    this.referalCount,
    this.updatedAt,
  });

  dynamic id;
  String? firstName;
  String? lastName;
  String? paymentMode;
  String? userType;
  String? email;
  String? gender;
  String? countryCode;
  String? mobile;
  dynamic picture;
  String? deviceToken;
  String? deviceId;
  String? deviceType;
  String? loginBy;
  dynamic socialUniqueId;
  dynamic latitude;
  dynamic longitude;
  dynamic stripeCustId;
  dynamic walletBalance;
  String? rating;
  dynamic otp;
  dynamic language;
  String? qrcodeUrl;
  String? referralUniqueId;
  dynamic referalCount;
  DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        paymentMode: json["payment_mode"],
        userType: json["user_type"],
        email: json["email"],
        gender: json["gender"],
        countryCode: json["country_code"],
        mobile: json["mobile"],
        picture: json["picture"],
        deviceToken: json["device_token"],
        deviceId: json["device_id"],
        deviceType: json["device_type"],
        loginBy: json["login_by"],
        socialUniqueId: json["social_unique_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        stripeCustId: json["stripe_cust_id"],
        walletBalance: json["wallet_balance"],
        rating: json["rating"],
        otp: json["otp"],
        language: json["language"],
        qrcodeUrl: json["qrcode_url"],
        referralUniqueId: json["referral_unique_id"],
        referalCount: json["referal_count"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "payment_mode": paymentMode,
        "user_type": userType,
        "email": email,
        "gender": gender,
        "country_code": countryCode,
        "mobile": mobile,
        "picture": picture,
        "device_token": deviceToken,
        "device_id": deviceId,
        "device_type": deviceType,
        "login_by": loginBy,
        "social_unique_id": socialUniqueId,
        "latitude": latitude,
        "longitude": longitude,
        "stripe_cust_id": stripeCustId,
        "wallet_balance": walletBalance,
        "rating": rating,
        "otp": otp,
        "language": language,
        "qrcode_url": qrcodeUrl,
        "referral_unique_id": referralUniqueId,
        "referal_count": referalCount,
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Provider {
  Provider({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.countryCode,
    this.mobile,
    this.avatar,
    this.rating,
    this.status,
    this.fleet,
    this.latitude,
    this.longitude,
    this.stripeAccId,
    this.stripeCustId,
    this.paypalEmail,
    this.loginBy,
    this.socialUniqueId,
    this.otp,
    this.walletBalance,
    this.referralUniqueId,
    this.qrcodeUrl,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? countryCode;
  String? mobile;
  String? avatar;
  String? rating;
  String? status;
  dynamic fleet;
  double? latitude;
  double? longitude;
  dynamic stripeAccId;
  dynamic stripeCustId;
  dynamic paypalEmail;
  String? loginBy;
  dynamic socialUniqueId;
  dynamic otp;
  double? walletBalance;
  String? referralUniqueId;
  dynamic qrcodeUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        gender: json["gender"],
        countryCode: json["country_code"],
        mobile: json["mobile"],
        avatar: json["avatar"],
        rating: json["rating"],
        status: json["status"],
        fleet: json["fleet"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        stripeAccId: json["stripe_acc_id"],
        stripeCustId: json["stripe_cust_id"],
        paypalEmail: json["paypal_email"],
        loginBy: json["login_by"],
        socialUniqueId: json["social_unique_id"],
        otp: json["otp"],
        walletBalance: json["wallet_balance"].toDouble(),
        referralUniqueId: json["referral_unique_id"],
        qrcodeUrl: json["qrcode_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "gender": gender,
        "country_code": countryCode,
        "mobile": mobile,
        "avatar": avatar,
        "rating": rating,
        "status": status,
        "fleet": fleet,
        "latitude": latitude,
        "longitude": longitude,
        "stripe_acc_id": stripeAccId,
        "stripe_cust_id": stripeCustId,
        "paypal_email": paypalEmail,
        "login_by": loginBy,
        "social_unique_id": socialUniqueId,
        "otp": otp,
        "wallet_balance": walletBalance,
        "referral_unique_id": referralUniqueId,
        "qrcode_url": qrcodeUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

ProviderService providerServiceFromJson(String str) =>
    ProviderService.fromJson(json.decode(str));

String providerServiceToJson(ProviderService data) =>
    json.encode(data.toJson());

class ProviderService {
  ProviderService({
    this.id,
    this.providerId,
    this.serviceTypeId,
    this.status,
    this.serviceNumber,
    this.serviceModel,this.car_color,this.car_camp_name
  });

  dynamic id;
  dynamic providerId;
  dynamic serviceTypeId;
  String? status;
  String? serviceNumber;
  String? serviceModel;
  String? car_camp_name;
  String? car_color;

  factory ProviderService.fromJson(Map<String, dynamic> json) =>
      ProviderService(
        id: json["id"],
        providerId: json["provider_id"],
        serviceTypeId: json["service_type_id"],
        status: json["status"],
        serviceNumber: json["service_number"],
        serviceModel: json["service_model"],
        car_color: json["car_color"],
        car_camp_name: json["car_camp_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "service_type_id": serviceTypeId,
        "status": status,
        "service_number": serviceNumber,
        "car_camp_name": car_camp_name,
        "car_color": car_color,
        "service_model": serviceModel,
      };
}

class MultiDestination {
  MultiDestination({
    this.id,
    this.requestId,
    this.latitude,
    this.longitude,
    this.finalDestination,
    this.createdAt,
    this.updatedAt,
    this.isPickedup,
    this.dAddress,
    this.deletedAt,
  });

  dynamic id;
  dynamic requestId;
  double? latitude;
  double? longitude;
  dynamic finalDestination;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic isPickedup;
  String? dAddress;
  dynamic deletedAt;

  factory MultiDestination.fromJson(Map<String, dynamic> json) =>
      MultiDestination(
        id: json["id"],
        requestId: json["request_id"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        finalDestination: json["final_destination"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isPickedup: json["is_pickedup"],
        dAddress: json["d_address"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_id": requestId,
        "latitude": latitude,
        "longitude": longitude,
        "final_destination": finalDestination,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_pickedup": isPickedup,
        "d_address": dAddress,
        "deleted_at": deletedAt,
      };
}
