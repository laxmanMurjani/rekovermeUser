import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/widget/custom_button.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/credit_card_type_detector.dart';

class AddCreditCardScreen extends StatefulWidget {
  @override
  State<AddCreditCardScreen> createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  int _cardNumberLength = 0;
  int _expiryDateLength = 0;

  @override
  void initState() {
    super.initState();

    _cardNumberController.addListener(() {});

    _expiryDateController.addListener(() {
      if (_expiryDateController.text.length < _expiryDateLength) {
        if (_expiryDateController.text.length == 3) {
          _expiryDateController.text =
              "${_expiryDateController.text[0]}${_expiryDateController.text[1]}";
        }
      } else if (_expiryDateController.text.length == 3) {
        _expiryDateController.text =
            "${_expiryDateController.text[0]}${_expiryDateController.text[1]}/${_expiryDateController.text[2]}";
      }
      _expiryDateLength = _expiryDateController.text.length;
      _expiryDateController.selection = TextSelection.fromPosition(
          TextPosition(offset: _expiryDateController.text.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "add_card_for_payments".tr,
      ),
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return Column(
          children: [
            SizedBox(height: 15.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 0.5, spreadRadius: 0.9),
                ],
                borderRadius: BorderRadius.circular(
                  20.r,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            labelText: "card_number".tr,
                            hintText: "card_number".tr,
                            // suffixIcon: _detectCardType(),
                          ),
                          onChanged: (s) {
                            setState(() {});
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      detectCardType(cardNumber: _cardNumberController.text)
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expiryDateController,
                          decoration: InputDecoration(
                            hintText: "expiration_date".tr,
                            labelText: "expiration_date".tr,
                            counterText: "",
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          controller: _cvvController,
                          decoration: InputDecoration(
                            hintText: "CVV",
                            labelText: "CVV",
                            counterText: "",
                          ),
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: CustomButton(
                text: "add_card".tr,
                onTap: () {
                  if (_expiryDateController.text.length != 5) {
                    cont.showError(msg: "please_insert_valid_expiry_date".tr);
                  }

                  Map<String, dynamic> params = {};
                  params["number"] = _cardNumberController.text;
                  params["exp_month"] = _expiryDateController.text.split("/")[0];
                  params["exp_year"] =  _expiryDateController.text.split("/")[1];
                  params["cvc"] = _cvvController.text;
                  cont.createCard(cardParams: params);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

}
Widget detectCardType({required String cardNumber}) {
  if (cardNumber.isEmpty) {
    return SizedBox(
      width: 0,
      height: 0,
    );
  }
  CreditCardType _creditCardType = detectCCType(cardNumber);

  IconData? iconData = null;
  switch (_creditCardType) {
    case CreditCardType.visa:
      iconData = FontAwesomeIcons.ccVisa;
      break;
    case CreditCardType.amex:
      iconData = FontAwesomeIcons.ccAmex;
      break;
    case CreditCardType.discover:
      iconData = FontAwesomeIcons.ccDiscover;
      break;
    case CreditCardType.mastercard:
      iconData = FontAwesomeIcons.ccMastercard;
      break;
    case CreditCardType.dinersclub:
      iconData = FontAwesomeIcons.ccDinersClub;
      break;
    case CreditCardType.jcb:
      iconData = FontAwesomeIcons.ccJcb;
      break;
    case CreditCardType.unionpay:
      iconData = Icons.payment;
      break;
    case CreditCardType.maestro:
      iconData = Icons.payment;
      break;
    case CreditCardType.elo:
      iconData = Icons.payment;
      break;
    case CreditCardType.mir:
      iconData = Icons.payment;
      break;
    case CreditCardType.hiper:
      iconData = Icons.payment;
      break;
    case CreditCardType.hipercard:
      iconData = Icons.payment;
      break;
    case CreditCardType.unknown:
      iconData = Icons.payment;
      break;
  }
  return Icon(iconData);
  return SizedBox(
    width: 0,
    height: 0,
  );
}

