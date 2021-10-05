import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllServicesScreen extends StatelessWidget {
  const AllServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Services",
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Get.back();
          },
        ),
      ),
    );
  }
}
