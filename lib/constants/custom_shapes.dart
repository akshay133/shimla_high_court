import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:high_court/constants/colors.dart';
import 'package:sizer/sizer.dart';

class CustomShapes {
  Widget textField(
      TextEditingController controller, String hintTxt, bool obscureTxt) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      obscureText: obscureTxt,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          hintText: hintTxt,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: primaryColor.withOpacity(0.4)),
          )),
    );
  }

  final boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
            color: iconColor.withOpacity(0.23),
            offset: const Offset(0, 5),
            blurRadius: 4,
            spreadRadius: 2)
      ]);
  final headlineTxtStyle = TextStyle(
    fontSize: 24.sp,
  );
  final bodyTxtStyle = TextStyle(fontSize: 20.sp, color: Colors.black38);
}
