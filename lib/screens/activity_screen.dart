import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:high_court/constants/apis.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:high_court/constants/timesago.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:sizer/sizer.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getActivityRepositories),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
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
          List repositories = result.data!['getUserActivities'];
          print("data:$repositories");
          return SizedBox(
            height: Get.height,
            child: ListView.builder(
                itemCount: repositories.length,
                itemBuilder: (ctx, index) {
                  final repository = repositories[index];
                  Moment rawDate = Moment.parse(repository['createdAt']);
                  var createdAt = TimeAgo.timeAgoSinceDate(
                      rawDate.format("dd-MM-yyyy h:mma"));
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: CustomShapes.boxDecoration,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text('${repository['message']}',
                                          style: CustomShapes.bodyTxtStyle
                                              .copyWith(
                                            fontSize: 14.sp,
                                          )),
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
                                    Text(
                                      rawDate.format("dd-MM-yyyy h:mma"),
                                      style: CustomShapes.bodyTxtStyle
                                          .copyWith(fontSize: 14.sp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
