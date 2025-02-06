import 'package:flutter/material.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/chart_helpers.dart';
import '../../../../core/util/widget/empty.dart';

/// @author : Jibin K John
/// @date   : 06/02/2025
/// @time   : 10:12:38

class MemberCategoryView extends StatelessWidget {
  final MembersChartData memberData;
  final List<CategoryChartData> categoryData;
  final Size size;

  const MemberCategoryView({
    super.key,
    required this.memberData,
    required this.categoryData,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(15.0),
          margin: EdgeInsets.all(AppHelper.horizontalPadding(size)),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10.0,
              ),
            ],
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: categoryData.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount Spent",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          AppHelper.formatAmount(
                            context,
                            memberData.amount,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    for (final category in categoryData)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 18.0,
                          backgroundColor:
                              category.category.color.withOpacity(.2),
                          child: Icon(
                            AppHelper.getIconFromString(
                              category.category.icon,
                            ),
                            size: 18.0,
                            color: category.category.color,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              category.category.name,
                              style: TextStyle(fontSize: 12.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Expanded(
                              child: Text(
                                AppHelper.formatAmount(
                                  context,
                                  category.amount,
                                ),
                                style: TextStyle(fontSize: 12.0),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        subtitle: LinearProgressIndicator(
                          minHeight: 5.0,
                          borderRadius: BorderRadius.circular(100.0),
                          value: category.amount / memberData.amount,
                          color: category.category.color,
                          backgroundColor:
                              category.category.color.withOpacity(.1),
                        ),
                      )
                  ],
                )
              : SizedBox(
                  height: size.height * .2,
                  child: Empty(message: "No transactions available"),
                ),
        ),
      ],
    );
  }
}
