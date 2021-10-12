import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:high_court/constants/apis.dart';
import 'package:high_court/constants/colors.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:high_court/constants/timesago.dart';
import 'package:high_court/controller/price_controller.dart';
import 'package:high_court/screens/ui/bottom_sheet_ui.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:sizer/sizer.dart';

class DuePaymentsListsScreen extends StatelessWidget {
  DuePaymentsListsScreen({Key? key}) : super(key: key);
  static const platform = MethodChannel("razorpay_flutter");
  final controller = Get.put(PriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Due payments",
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
          document: gql(getUserPaymentRepositories),
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
          List repositories = result.data!['getUserPayments'];
          print("data:$repositories");
          return ListView.builder(
            itemCount: repositories.length,
            itemBuilder: (ctx, index) {
              final repository = repositories[index];
              final ls = repository['list'] as List;
              Moment rawDate = Moment.parse(repository['createdAt']);
              var createdAt =
                  TimeAgo.timeAgoSinceDate(rawDate.format("dd-MM-yyyy h:mma"));
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
                                Text(
                                  'Status:',
                                  style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 1.2.w,
                                ),
                                Text(
                                  "${repository['status']}",
                                  style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 14.sp, color: Colors.red),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Event:',
                                  style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "One Month Payment",
                                  style: CustomShapes.bodyTxtStyle.copyWith(
                                    fontSize: 14.sp,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Total Service:",
                                  style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${ls.length}",
                                  style: CustomShapes.bodyTxtStyle.copyWith(
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Time:",
                                      style: CustomShapes.bodyTxtStyle.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      rawDate.format("dd-MM-yyyy h:mma"),
                                      style: CustomShapes.bodyTxtStyle.copyWith(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: primaryColor,
                                      ),
                                      onPressed: () {
                                        controller.setService(ls.obs);
                                        Get.bottomSheet(BottomSheetUi(),
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)));
                                      },
                                      child: const Text('View')),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
