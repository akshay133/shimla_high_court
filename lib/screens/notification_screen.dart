import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:high_court/constants/apis.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:high_court/constants/timesago.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:sizer/sizer.dart';

class NotificationUI extends StatelessWidget {
  const NotificationUI({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(notificationRepositories),
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
          List repositories = result.data!['notifications'];
          print("data:$repositories");
          return SizedBox(
            height: Get.height,
            child: repositories.isEmpty
                ? Center(
                    child: Text(
                      'Sorry! No data found',
                      style: CustomShapes.bodyTxtStyle,
                    ),
                  )
                : ListView.builder(
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
                                          child: Text(
                                              '${repository['message']}',
                                              style: CustomShapes.bodyTxtStyle
                                                  .copyWith(
                                                fontSize: 14.sp,
                                              )),
                                        ),
                                        repository['type'] == "Red"
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red),
                                                child: Center(
                                                  child: Text(
                                                    '${repository['type']}',
                                                    style: CustomShapes
                                                        .bodyTxtStyle
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ))
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green),
                                                child: Center(
                                                  child: Text(
                                                    '${repository['type']}',
                                                    style: CustomShapes
                                                        .bodyTxtStyle
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Created at:",
                                          style: CustomShapes.bodyTxtStyle
                                              .copyWith(
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
