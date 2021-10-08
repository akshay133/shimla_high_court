import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_court/constants/constants.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:hive/hive.dart';
import 'package:sizer/sizer.dart';

class ProfileUi extends StatefulWidget {
  ProfileUi({Key? key}) : super(key: key);

  @override
  State<ProfileUi> createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  double height = 10.h;
  double height2 = 10.h;
  double width = 10.w;
  var name;
  var email;
  @override
  void initState() {
    var box = Hive.box("myBox");
    name = box.get("name");
    email = box.get("email");
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
              style: CustomShapes.headlineTxtStyle.copyWith(
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
          decoration: CustomShapes.boxDecoration,
          duration: const Duration(seconds: 1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: CachedNetworkImageProvider(profileImg),
                ),
                Text(
                  name,
                  style: CustomShapes.bodyTxtStyle,
                ),
                Text(
                  email,
                  style: CustomShapes.bodyTxtStyle,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
