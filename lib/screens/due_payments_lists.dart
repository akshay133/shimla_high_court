import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DuePaymentsListsScreen extends StatelessWidget {
  const DuePaymentsListsScreen({Key? key}) : super(key: key);
  final String readRepositories = """
  query getUserPayments {
  getUserPayments {
     id
    status
    createdAt
    month
    list {
      serviceName
      serviceId
      price
    }
  }
}
  """;
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
          document: gql(readRepositories),
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
          return Text("");
          // return ListView.builder(
          //     itemCount: repositories.length,
          //     itemBuilder: (ctx, index) {
          //       final repository = repositories[index];
          //       Moment rawDate = Moment.parse(repository['createdAt']);
          //       var createdAt = TimeAgo.timeAgoSinceDate(
          //           rawDate.format("dd-MM-yyyy h:mma"));
          //       print("date:${rawDate.format("dd-MM-yyyy h:mma")}");
          //       return Padding(
          //         padding: const EdgeInsets.all(10.0),
          //         child: Container(
          //           padding: const EdgeInsets.all(12),
          //           decoration: CustomShapes.boxDecoration,
          //           child: Column(
          //             children: [
          //               Row(
          //                 children: [
          //                   Text(
          //                     "Unique Id:",
          //                     style: CustomShapes.bodyTxtStyle.copyWith(
          //                         fontSize: 14.sp, fontWeight: FontWeight.bold),
          //                   ),
          //                   SizedBox(
          //                     width: 1.2.w,
          //                   ),
          //                   Text(
          //                     "${repository['uniq']}",
          //                     style: CustomShapes.bodyTxtStyle.copyWith(
          //                       fontSize: 14.sp,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 children: [
          //                   Text(
          //                     "Item name:",
          //                     style: CustomShapes.bodyTxtStyle.copyWith(
          //                         fontSize: 14.sp, fontWeight: FontWeight.bold),
          //                   ),
          //                   SizedBox(
          //                     width: 1.2.w,
          //                   ),
          //                   Text(
          //                     "${repository['servicesName']}",
          //                     style: CustomShapes.bodyTxtStyle.copyWith(
          //                       fontSize: 14.sp,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 children: [
          //                   Text(
          //                     "Item price:",
          //                     style: CustomShapes.bodyTxtStyle.copyWith(
          //                         fontSize: 14.sp, fontWeight: FontWeight.bold),
          //                   ),
          //                   SizedBox(
          //                     width: 1.2.w,
          //                   ),
          //                   Text(
          //                     "${repository['servicesPrice']}",
          //                     style: CustomShapes.bodyTxtStyle.copyWith(
          //                       fontSize: 14.sp,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 children: [
          //                   Text(
          //                     "Created at:",
          //                     style: CustomShapes.bodyTxtStyle.copyWith(
          //                         fontSize: 14.sp, fontWeight: FontWeight.bold),
          //                   ),
          //                   SizedBox(
          //                     width: 1.2.w,
          //                   ),
          //                   Text(
          //                     createdAt.toString(),
          //                     style: CustomShapes.bodyTxtStyle.copyWith(
          //                       fontSize: 14.sp,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     });
        },
      ),
    );
  }
}
