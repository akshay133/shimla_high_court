import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:high_court/constants/apis.dart';
import 'package:high_court/constants/colors.dart';
import 'package:high_court/screens/home_screen_main.dart';
import 'package:high_court/screens/login_screen.dart';
import 'package:hive/hive.dart';
import 'package:sizer/sizer.dart';

import 'controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await Hive.openBox("myBox");
  Get.lazyPut(() => AuthController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var localToken;
  getTokenLocally() {
    localToken = Hive.box("myBox").get("token");
  }

  handleUi() {
    if (Get.find<AuthController>().token == "" && localToken == "") {
      return const LoginScreen();
    } else {
      return const HomeScreenMain();
    }
  }

  @override
  void initState() {
    getTokenLocally();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      baseUrl,
    );
    final AuthLink authLink = AuthLink(
        getToken: () =>
            'Bearer ${Get.find<AuthController>().token == "" ? localToken : Get.find<AuthController>().token}');
    final Link link = authLink.concat(httpLink);
    print(
        "Token:${Get.find<AuthController>().token == "" ? localToken : Get.find<AuthController>().token}");
    ValueNotifier<GraphQLClient> client = ValueNotifier(
        GraphQLClient(link: link, cache: GraphQLCache(store: HiveStore())));
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return GraphQLProvider(
          client: client,
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.zoom,
            theme: ThemeData(
              primaryColor: primaryColor,
              appBarTheme: const AppBarTheme(color: primaryColor),
              textTheme: GoogleFonts.nunitoTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            home: handleUi(),
          ),
        );
      },
    );
  }
}
