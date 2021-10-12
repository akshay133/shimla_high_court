import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:high_court/constants/apis.dart';
import 'package:high_court/constants/colors.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:high_court/controller/auth_controller.dart';
import 'package:high_court/screens/home_screen_main.dart';
import 'package:hive/hive.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _shapes = CustomShapes();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final double _width = double.infinity;
  late double _height = 2.h;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
          _height = 36.h;
        }));
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Mutation(
        options: MutationOptions(
          document: gql(loinMutation),
          onCompleted: (result) {
            Get.snackbar("Login", "Success",
                snackPosition: SnackPosition.BOTTOM, colorText: Colors.white);
          },
          onError: (error) {
            Get.snackbar("Error!", error!.graphqlErrors[0].message,
                snackPosition: SnackPosition.BOTTOM, colorText: Colors.white);
          },
        ),
        builder: (MultiSourceResult Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult? result) {
          return Container(
            color: primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    width: _width,
                    height: _height,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.24),
                              offset: const Offset(0, 5),
                              spreadRadius: 4,
                              blurRadius: 32),
                        ]),
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOutSine,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Sign In",
                            style: CustomShapes.headlineTxtStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: _shapes.textField(
                                _emailController, "Enter email address", false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: _shapes.textField(
                                _passwordController, 'Password', true),
                          ),
                          SizedBox(
                            height: 1.2.h,
                          ),
                          if (result!.isLoading && result.data == null)
                            const CircularProgressIndicator()
                          else
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: btnColor,
                                    minimumSize: Size(double.infinity, 5.5.h),
                                    shape: const StadiumBorder()),
                                onPressed: () async {
                                  if (_emailController.text.isEmpty ||
                                      _passwordController.text.isEmpty) {
                                    Get.snackbar(
                                        "Error!", "All fields are required",
                                        snackPosition: SnackPosition.BOTTOM,
                                        colorText: Colors.white);
                                  } else {
                                    var resultMutaion = runMutation({
                                      "email": _emailController.text.trim(),
                                      "password":
                                          _passwordController.text.trim()
                                    });
                                    var result =
                                        await resultMutaion.networkResult;
                                    var box = Hive.box("myBox");
                                    box.put(
                                        "name",
                                        result!.data!['memberLogin']
                                            ['username']);
                                    box.put("email",
                                        result.data!['memberLogin']['email']);
                                    box
                                        .put(
                                            "token",
                                            result.data!['memberLogin']
                                                ['token'])
                                        .then((value) {
                                      Get.find<AuthController>().setUserData(
                                          result.data!['memberLogin']['token'],
                                          result.data!['memberLogin']
                                                  ['username']
                                              .toString()
                                              .obs,
                                          result.data!['memberLogin']['email']
                                              .toString()
                                              .obs);
                                      Get.to(const HomeScreenMain());
                                    });
                                  }
                                },
                                child: const Text('login')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
