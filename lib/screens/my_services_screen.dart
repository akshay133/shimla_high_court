import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:high_court/constants/apis.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:high_court/constants/timesago.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:sizer/sizer.dart';

class MyServicesScreen extends StatelessWidget {
  MyServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "My Services",
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getUserServiceRepositories),
        ),
        builder: (
          QueryResult? result, {
          Refetch? refetch,
          FetchMore? fetchMore,
        }) {
          if (result!.hasException) {
            Future.delayed(Duration.zero, () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      result.exception!.graphqlErrors[0].message.toString())));
            });
          }
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List repositories = result.data!['getUserServices'];

          print("data:$repositories");
          return ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (ctx, index) {
                final repository = repositories[index];
                Moment rawDate = Moment.parse(repository['createdAt']);
                var createdAt = TimeAgo.timeAgoSinceDate(
                    rawDate.format("dd-MM-yyyy h:mma"));
                print("date:${rawDate.format("dd-MM-yyyy h:mma")}");
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: CustomShapes.boxDecoration,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Unique Id:",
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 1.2.w,
                                  ),
                                  Text(
                                    "${repository['uniq']}",
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Item name:",
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 1.2.w,
                                  ),
                                  Text(
                                    "${repository['servicesName']}",
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Item price:",
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 1.2.w,
                                  ),
                                  Text(
                                    "${repository['servicesPrice']}",
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Created at:",
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 1.2.w,
                                  ),
                                  Text(
                                    rawDate.format("dd-MM-yyyy h:mma"),
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
