import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:high_court/constants/apis.dart';
import 'package:high_court/constants/colors.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:high_court/constants/timesago.dart';
import 'package:high_court/controller/list_controller.dart';
import 'package:high_court/screens/ui/payment_history_sheet_ui.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:sizer/sizer.dart';

class PaymentHistoryScreen extends StatelessWidget {
  PaymentHistoryScreen({Key? key}) : super(key: key);
  final controller = Get.put(ListController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Payment History"),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getPaymentRepositories),
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
          List repositories = result.data!['userAllPayments'];
          print("data:$repositories");
          return ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (ctx, index) {
                final repository = repositories[index];
                final ls = repository['paymentBilling'] as List;
                Moment rawDate = Moment.parse(repository['createdAt']);
                var createdAt = TimeAgo.timeAgoSinceDate(
                    rawDate.format("dd-MM-yyyy h:mma"));
                var month = rawDate.format("MMM");
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
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
                                      fontSize: 14.sp, color: Colors.green),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Text('Month:',
                                        style: CustomShapes.bodyTxtStyle
                                            .copyWith(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold)),
                                    Text(month,
                                        style:
                                            CustomShapes.bodyTxtStyle.copyWith(
                                          fontSize: 14.sp,
                                        )),
                                  ],
                                ),
                                const Spacer(),
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: primaryColor),
                                      onPressed: () {
                                        controller.setService(ls.obs);
                                        Get.bottomSheet(PaymentHistorySheetUi(),
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)));
                                      },
                                      child: const Text("Details")),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text('Created at:',
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold)),
                                Text(createdAt,
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 14.sp,
                                    ))
                              ],
                            ),
                          ],
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
