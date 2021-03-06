import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:high_court/screens/my_services_screen.dart';
import 'package:sizer/sizer.dart';

class DashBoardUi extends StatefulWidget {
  const DashBoardUi({Key? key}) : super(key: key);

  @override
  State<DashBoardUi> createState() => _DashBoardUiState();
}

class _DashBoardUiState extends State<DashBoardUi> {
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
              "Dashboard",
              style: CustomShapes.headlineTxtStyle.copyWith(
                  color: Colors.black54,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () => Get.to(MyServicesScreen()),
            child: AnimatedContainer(
              height: height,
              width: Get.width / 2,
              curve: Curves.elasticOut,
              alignment: Alignment.center,
              duration: const Duration(seconds: 1),
              padding: const EdgeInsets.all(12),
              decoration: CustomShapes.boxDecoration,
              child: Text(
                'Services',
                style: CustomShapes.bodyTxtStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
