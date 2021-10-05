import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_court/controller/dashboard_data_controller.dart';

class DashboardTilesDetailScreen extends StatelessWidget {
  DashboardTilesDetailScreen({Key? key}) : super(key: key);
  final dashController = Get.put(DashBoardDataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dashController.title),
      ),
    );
  }
}
