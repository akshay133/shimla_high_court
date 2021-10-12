import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:high_court/screens/due_payments_lists.dart';
import 'package:sizer/sizer.dart';

class DuePaymentUI extends StatefulWidget {
  const DuePaymentUI({Key? key}) : super(key: key);

  @override
  State<DuePaymentUI> createState() => _DuePaymentUIState();
}

class _DuePaymentUIState extends State<DuePaymentUI> {
  double height = 8.h;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
          height = 20.h;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          AnimatedContainer(
            height: height,
            curve: Curves.elasticOut,
            duration: const Duration(seconds: 1),
            child: Text(
              "Payments",
              style: CustomShapes.headlineTxtStyle.copyWith(
                  color: Colors.black54,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () => Get.to(DuePaymentsListsScreen()),
            child: AnimatedContainer(
              height: height,
              width: Get.width / 2,
              curve: Curves.elasticOut,
              alignment: Alignment.center,
              duration: const Duration(seconds: 1),
              padding: const EdgeInsets.all(12),
              decoration: CustomShapes.boxDecoration,
              child: Text(
                'Due Payments',
                style: CustomShapes.bodyTxtStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
