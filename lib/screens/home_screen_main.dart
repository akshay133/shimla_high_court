import 'package:cached_network_image/cached_network_image.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_court/constants/colors.dart';
import 'package:high_court/constants/constants.dart';
import 'package:high_court/screens/login_screen.dart';
import 'package:high_court/screens/ui/dashboard_ui.dart';
import 'package:high_court/screens/ui/due_payment_ui.dart';
import 'package:high_court/screens/ui/profile_ui.dart';
import 'package:hive/hive.dart';
import 'package:sizer/sizer.dart';

class HomeScreenMain extends StatefulWidget {
  const HomeScreenMain({Key? key}) : super(key: key);

  @override
  State<HomeScreenMain> createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  late List<CollapsibleItem> _items;
  var name;
  @override
  void initState() {
    var box = Hive.box("myBox");
    name = box.get("name");
    super.initState();
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
        text: 'Due Payments',
        icon: Icons.account_balance_wallet_outlined,
        onPressed: () => setState(() {}),
      ),
      CollapsibleItem(
          text: 'Profile', icon: Icons.face, onPressed: () => setState(() {})),
      CollapsibleItem(
          text: 'Logout',
          icon: Icons.logout_outlined,
          onPressed: () async {
            await Hive.box("myBox").clear().then((value) {
              Get.offAll(const LoginScreen());
            });
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
        title: name,
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
            if (_items.elementAt(2).isSelected) const DuePaymentUI(),
            if (_items.elementAt(3).isSelected) ProfileUi(),
          ],
        ),
      ),
    );
  }
}
