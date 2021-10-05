import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_court/constants/constants.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:high_court/controller/profile_controller.dart';
import 'package:sizer/sizer.dart';

class ProfileUi extends StatefulWidget {
  ProfileUi({Key? key}) : super(key: key);

  @override
  State<ProfileUi> createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  final profileController = Get.put(ProfileController());
  final customShapes = CustomShapes();
  double height = 10.h;
  double height2 = 10.h;
  double width = 10.w;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
          height = 15.h;
          height2 = 22.h;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: AnimatedContainer(
            height: height,
            curve: Curves.elasticOut,
            duration: const Duration(seconds: 1),
            child: Text(
              "My Profile",
              style: customShapes.headlineTxtStyle.copyWith(
                  color: Colors.black54,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        AnimatedContainer(
          height: height2,
          width: Get.width / 2,
          curve: Curves.elasticOut,
          padding: const EdgeInsets.all(12),
          decoration: customShapes.boxDecoration,
          duration: const Duration(seconds: 1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: CachedNetworkImageProvider(profileImg),
                ),
                Text(
                  profileController.name,
                  style: customShapes.bodyTxtStyle,
                ),
                Text(
                  profileController.email,
                  style: customShapes.bodyTxtStyle,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
