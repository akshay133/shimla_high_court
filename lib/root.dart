import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:high_court/screens/login_screen.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
        "https://88ec-2405-201-7003-809c-7b23-9d41-4aec-aaa5.ngrok.io/");
    final ValueNotifier<GraphQLClient> client = ValueNotifier(
        GraphQLClient(link: httpLink, cache: GraphQLCache(store: HiveStore())));
    return GraphQLProvider(
      client: client,
      child: LoginScreen(),
    );
  }
}
