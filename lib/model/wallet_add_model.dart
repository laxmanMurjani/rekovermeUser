import 'dart:convert';

WalletAddModel walletAddModelFromJson(String str) =>
    WalletAddModel.fromJson(json.decode(str));

String walletAddModelToJson(WalletAddModel data) => json.encode(data.toJson());

class WalletAddModel {
  WalletAddModel({
    this.status = false,
    this.message,
    this.data,
  });

  bool status;
  String? message;
  Data? data;

  factory WalletAddModel.fromJson(Map<String, dynamic> json) => WalletAddModel(
        status: json["status"] == true,
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.publishableKey,
    this.clientSecret,
    this.intent,
  });

  String? publishableKey;
  String? clientSecret;
  Intent? intent;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        publishableKey: json["publishableKey"],
        clientSecret: json["clientSecret"],
        intent: json["intent"] == null ? null : Intent.fromJson(json["intent"]),
      );

  Map<String, dynamic> toJson() => {
        "publishableKey": publishableKey,
        "clientSecret": clientSecret,
        "intent": intent?.toJson(),
      };
}

class Intent {
  Intent({
    this.id,
    this.object,
    this.amount,
    this.amountCapturable,
    this.amountDetails,
    this.amountReceived,
    this.application,
    this.applicationFeeAmount,
    this.automaticPaymentMethods,
    this.canceledAt,
    this.cancellationReason,
    this.captureMethod,
    this.charges,
    this.clientSecret,
    this.confirmationMethod,
    this.created,
    this.currency,
    this.customer,
    this.description,
    this.invoice,
    this.lastPaymentError,
    this.livemode = false,
    this.metadata = const [],
    this.nextAction,
    this.onBehalfOf,
    this.paymentMethod,
    this.paymentMethodOptions,
    this.paymentMethodTypes = const [],
    this.processing,
    this.receiptEmail,
    this.review,
    this.setupFutureUsage,
    this.shipping,
    this.source,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    this.status,
    this.transferData,
    this.transferGroup,
  });

  String? id;
  String? object;
  int? amount;
  int? amountCapturable;
  AmountDetails? amountDetails;
  int? amountReceived;
  dynamic application;
  dynamic applicationFeeAmount;
  dynamic automaticPaymentMethods;
  dynamic canceledAt;
  dynamic cancellationReason;
  String? captureMethod;
  Charges? charges;
  String? clientSecret;
  String? confirmationMethod;
  int? created;
  String? currency;
  String? customer;
  String? description;
  dynamic invoice;
  dynamic lastPaymentError;
  bool livemode;
  List<dynamic> metadata;
  NextAction? nextAction;
  dynamic onBehalfOf;
  String? paymentMethod;
  PaymentMethodOptions? paymentMethodOptions;
  List<String> paymentMethodTypes;
  dynamic processing;
  dynamic receiptEmail;
  dynamic review;
  dynamic setupFutureUsage;
  dynamic shipping;
  dynamic source;
  dynamic statementDescriptor;
  dynamic statementDescriptorSuffix;
  String? status;
  dynamic transferData;
  dynamic transferGroup;

  factory Intent.fromJson(Map<String, dynamic> json) => Intent(
        id: json["id"],
        object: json["object"],
        amount: json["amount"],
        amountCapturable: json["amount_capturable"],
        amountDetails: json["amount_details"] == null
            ? null
            : AmountDetails.fromJson(json["amount_details"]),
        amountReceived: json["amount_received"],
        application: json["application"],
        applicationFeeAmount: json["application_fee_amount"],
        automaticPaymentMethods: json["automatic_payment_methods"],
        canceledAt: json["canceled_at"],
        cancellationReason: json["cancellation_reason"],
        captureMethod: json["capture_method"],
        charges:
            json["charges"] == null ? null : Charges.fromJson(json["charges"]),
        clientSecret: json["client_secret"],
        confirmationMethod: json["confirmation_method"],
        created: json["created"],
        currency: json["currency"],
        customer: json["customer"],
        description: json["description"],
        invoice: json["invoice"],
        lastPaymentError: json["last_payment_error"],
        livemode: json["livemode"],
        metadata: json["metadata"] == null
            ? []
            : List<dynamic>.from(json["metadata"].map((x) => x)),
        nextAction: json["next_action"] == null
            ? null
            : NextAction.fromJson(json["next_action"]),
        onBehalfOf: json["on_behalf_of"],
        paymentMethod: json["payment_method"],
        paymentMethodOptions: json["payment_method_options"] == null
            ? null
            : PaymentMethodOptions.fromJson(json["payment_method_options"]),
        paymentMethodTypes: json["payment_method_types"] == null
            ? []
            : List<String>.from(json["payment_method_types"].map((x) => x)),
        processing: json["processing"],
        receiptEmail: json["receipt_email"],
        review: json["review"],
        setupFutureUsage: json["setup_future_usage"],
        shipping: json["shipping"],
        source: json["source"],
        statementDescriptor: json["statement_descriptor"],
        statementDescriptorSuffix: json["statement_descriptor_suffix"],
        status: json["status"],
        transferData: json["transfer_data"],
        transferGroup: json["transfer_group"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "amount": amount,
        "amount_capturable": amountCapturable,
        "amount_details": amountDetails?.toJson(),
        "amount_received": amountReceived,
        "application": application,
        "application_fee_amount": applicationFeeAmount,
        "automatic_payment_methods": automaticPaymentMethods,
        "canceled_at": canceledAt,
        "cancellation_reason": cancellationReason,
        "capture_method": captureMethod,
        "charges": charges?.toJson(),
        "client_secret": clientSecret,
        "confirmation_method": confirmationMethod,
        "created": created,
        "currency": currency,
        "customer": customer,
        "description": description,
        "invoice": invoice,
        "last_payment_error": lastPaymentError,
        "livemode": livemode,
        "metadata": List<dynamic>.from(metadata.map((x) => x)),
        "next_action": nextAction?.toJson(),
        "on_behalf_of": onBehalfOf,
        "payment_method": paymentMethod,
        "payment_method_options": paymentMethodOptions?.toJson(),
        "payment_method_types":
            List<dynamic>.from(paymentMethodTypes.map((x) => x)),
        "processing": processing,
        "receipt_email": receiptEmail,
        "review": review,
        "setup_future_usage": setupFutureUsage,
        "shipping": shipping,
        "source": source,
        "statement_descriptor": statementDescriptor,
        "statement_descriptor_suffix": statementDescriptorSuffix,
        "status": status,
        "transfer_data": transferData,
        "transfer_group": transferGroup,
      };
}

class AmountDetails {
  AmountDetails({
    this.tip = const [],
  });

  List<dynamic> tip;

  factory AmountDetails.fromJson(Map<String, dynamic> json) => AmountDetails(
        tip: json["tip"] == null
            ? []
            : List<dynamic>.from(json["tip"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "tip": List<dynamic>.from(tip.map((x) => x)),
      };
}

class Charges {
  Charges({
    this.object,
    this.data = const [],
    this.hasMore = false,
    this.totalCount,
    this.url,
  });

  String? object;
  List<dynamic> data;
  bool hasMore;
  int? totalCount;
  String? url;

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
        object: json["object"],
        data: json["data"] == null
            ? []
            : List<dynamic>.from(json["data"].map((x) => x)),
        hasMore: json["has_more"] == false,
        totalCount: json["total_count"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "data": List<dynamic>.from(data.map((x) => x)),
        "has_more": hasMore,
        "total_count": totalCount,
        "url": url,
      };
}

class NextAction {
  NextAction({
    this.type,
    this.useStripeSdk,
  });

  String? type;
  UseStripeSdk? useStripeSdk;

  factory NextAction.fromJson(Map<String, dynamic> json) => NextAction(
        type: json["type"],
        useStripeSdk: json["use_stripe_sdk"] == null?null:UseStripeSdk.fromJson(json["use_stripe_sdk"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "use_stripe_sdk": useStripeSdk?.toJson(),
      };
}

class UseStripeSdk {
  UseStripeSdk({
    this.type,
    this.stripeJs,
    this.source,
  });

  String? type;
  String? stripeJs;
  String? source;

  factory UseStripeSdk.fromJson(Map<String, dynamic> json) => UseStripeSdk(
        type: json["type"],
        stripeJs: json["stripe_js"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "stripe_js": stripeJs,
        "source": source,
      };
}

class PaymentMethodOptions {
  PaymentMethodOptions({
    this.card,
  });

  Card? card;

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) =>
      PaymentMethodOptions(
        card: json["card"] == null?null:Card.fromJson(json["card"]),
      );

  Map<String, dynamic> toJson() => {
        "card": card?.toJson(),
      };
}

class Card {
  Card({
    this.installments,
    this.mandateOptions,
    this.network,
    this.requestThreeDSecure,
  });

  dynamic installments;
  dynamic mandateOptions;
  dynamic network;
  String? requestThreeDSecure;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        installments: json["installments"],
        mandateOptions: json["mandate_options"],
        network: json["network"],
        requestThreeDSecure: json["request_three_d_secure"],
      );

  Map<String, dynamic> toJson() => {
        "installments": installments,
        "mandate_options": mandateOptions,
        "network": network,
        "request_three_d_secure": requestThreeDSecure,
      };
}
