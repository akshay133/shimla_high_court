import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:high_court/constants/custom_shapes.dart';
import 'package:high_court/controller/list_controller.dart';
import 'package:sizer/sizer.dart';

class PaymentHistorySheetUi extends StatelessWidget {
  PaymentHistorySheetUi({Key? key}) : super(key: key);
  int count = 1;
  double? totalPrice;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            'Payments History',
            style: CustomShapes.bodyTxtStyle
                .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          GetBuilder<ListController>(
              init: ListController(),
              builder: (_) {
                totalPrice = _.ls
                    .map((item) => double.parse(item['price']))
                    .reduce((a, b) => a + b);
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Service Name",
                          style: CustomShapes.bodyTxtStyle.copyWith(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Service Price',
                          style: CustomShapes.bodyTxtStyle.copyWith(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(),
                    for (var item in _.ls)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${count++}.",
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    '${item['serviceName']}',
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Rs:",
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    '${item['price']}',
                                    style: CustomShapes.bodyTxtStyle.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    const Divider(),
                    Text(
                      'Total Paid:$totalPrice',
                      style: CustomShapes.bodyTxtStyle.copyWith(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }
}
