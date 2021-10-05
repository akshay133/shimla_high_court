import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:high_court/constants/apis.dart';
import 'package:hive/hive.dart';

class Config {
  static var box = Hive.box("myBox");
  static var token = box.get("token");
  static var name = box.get("name");
  static var email = box.get("email");
  static final HttpLink httpLink = HttpLink(
    baseUrl,
  );
  static final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer $token',
    // OR
    // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  );
  static final Link link = authLink.concat(httpLink);
  static ValueNotifier<GraphQLClient> initializeClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
        GraphQLClient(link: link, cache: GraphQLCache(store: HiveStore())));
    return client;
  }
}
