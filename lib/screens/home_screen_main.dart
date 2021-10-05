import 'package:cached_network_image/cached_network_image.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_court/config/config.dart';
import 'package:high_court/constants/colors.dart';
import 'package:high_court/constants/constants.dart';
import 'package:high_court/controller/profile_controller.dart';
import 'package:high_court/screens/login_screen.dart';
import 'package:high_court/screens/ui/dashboard_ui.dart';
import 'package:high_court/screens/ui/profile_ui.dart';
import 'package:hive/hive.dart';
import 'package:sizer/sizer.dart';

class HomeScreenMain extends StatefulWidget {
  const HomeScreenMain({Key? key}) : super(key: key);

  @override
  State<HomeScreenMain> createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  final profileController = Get.put(ProfileController());
  late List<CollapsibleItem> _items;

  var name;
  var email;

  @override
  void initState() {
    super.initState();
    name = Config.name;
    email = Config.email;
    profileController.setName(name);
    profileController.setEmail(email);
    _items = _generateItems;
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'Dashboard',
        icon: Icons.assessment,
        onPressed: () => setState(() {}),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'Notifications',
        icon: Icons.notifications,
        onPressed: () => setState(() {}),
      ),
      CollapsibleItem(
          text: 'Profile', icon: Icons.face, onPressed: () => setState(() {})),
      CollapsibleItem(
          text: 'Logout',
          icon: Icons.logout_outlined,
          onPressed: () {
            var box = Hive.box("myBox");
            box.clear();
            Get.off(const LoginScreen());
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: CollapsibleSidebar(
        isCollapsed: true,
        items: _items,
        avatarImg: const CachedNetworkImageProvider(
          profileImg,
        ),
        title: name.toString(),
        onTitleTap: () {},
        body: _body(size, context),
        backgroundColor: primaryColor,
        selectedTextColor: Colors.white,
        unselectedIconColor: iconColor,
        selectedIconBox: iconColor,
        selectedIconColor: Colors.white,
        sidebarBoxShadow: const [
          BoxShadow(
            color: iconColor,
            blurRadius: 10,
            spreadRadius: 0.01,
            offset: Offset(3, 3),
          ),
        ],
        textStyle: TextStyle(
          fontSize: 15.sp,
        ),
        titleStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget _body(Size size, BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blueGrey[50],
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (_items.elementAt(0).isSelected) const DashBoardUi(),
            if (_items.elementAt(1).isSelected) const Text('Notifications'),
            if (_items.elementAt(2).isSelected) ProfileUi(),
          ],
        ),
      ),
    );
  }
}
