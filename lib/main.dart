import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:high_court/config/config.dart';
import 'package:high_court/constants/colors.dart';
import 'package:high_court/screens/home_screen_main.dart';
import 'package:high_court/screens/login_screen.dart';
import 'package:hive/hive.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await Hive.openBox("myBox");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var token;
  handleAuth() {
    setState(() {
      token = Config.token;
    });
  }

  @override
  void initState() {
    handleAuth();
    super.initState();
  }

  handleUi() {
    if (token == null) {
      return const LoginScreen();
    } else {
      return const HomeScreenMain();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return GraphQLProvider(
          client: Config.initializeClient(),
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.zoom,
            theme: ThemeData(
              primaryColor: primaryColor,
              appBarTheme: AppBarTheme(color: primaryColor),
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
