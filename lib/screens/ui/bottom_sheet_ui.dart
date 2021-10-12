import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_court/constants/colors.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:high_court/controller/price_controller.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';

class BottomSheetUi extends StatefulWidget {
  BottomSheetUi({Key? key}) : super(key: key);

  @override
  State<BottomSheetUi> createState() => _BottomSheetUiState();
}

class _BottomSheetUiState extends State<BottomSheetUi> {
  int count = 1;

  double? totalPrice;

  late Razorpay _razorpay;
  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': totalPrice! * 100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.snackbar("Success", response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      "ERROR",
      response.code.toString() + "-" + response.message!,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("EXTERNAL_WALLET", response.walletName!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            'Payments',
            style: CustomShapes.bodyTxtStyle
                .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          GetBuilder<PriceController>(
              init: PriceController(),
              builder: (_) {
                totalPrice = _.ls
                    .map((item) => double.parse(item['price']))
                    .reduce((a, b) => a + b);

                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Service Name",
                          style: CustomShapes.bodyTxtStyle.copyWith(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Service Price',
                          style: CustomShapes.bodyTxtStyle.copyWith(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(),
                    for (var item in _.ls)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${count++}.",
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    '${item['serviceName']}',
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Rs:",
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    '${item['price']}',
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    const Divider(),
                    Text(
                      'Total Price:$totalPrice',
                      style: CustomShapes.bodyTxtStyle.copyWith(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 40.0.w,
                      child: ElevatedButton(
                          onPressed: openCheckout,
                          style:
                              ElevatedButton.styleFrom(primary: primaryColor),
                          child: const Text("Pay")),
                    )
                  ],
                );
              }),
        ],
      ),
    );
  }
}
