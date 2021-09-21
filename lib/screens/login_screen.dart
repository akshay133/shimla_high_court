import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String query = """
  mutation LoginMutation(\$email: String!, \$password: String!) {
  login(username: \$email, password: \$password) {
    id
    token
    username
  }
}""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Mutation(
        options: MutationOptions(
            document: gql(query),
            onCompleted: (dynamic resultData) {
              Get.snackbar("Login Success", "");
            },
            onError: (error) {
              Get.snackbar("Error!", error!.graphqlErrors[0].message);
            }),
        builder: (MultiSourceResult Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult? result) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: "email"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(hintText: "password"),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    runMutation({
                      "email": _emailController.text,
                      "password": _passwordController.text
                    });
                  },
                  child: const Text('login')),
              if (result!.data != null)
                Text('Result: \n ${result.data!["login"]["username"]}')
              else
                Container()
            ],
          );
        },
      ),
    );
  }
}
