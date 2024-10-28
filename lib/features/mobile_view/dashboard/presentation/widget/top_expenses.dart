import 'package:flutter/material.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/view_model/dashboard_helper.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../common/data/model/expense_model.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 19:54:24

class TopExpenses extends StatelessWidget {
  final List<ExpenseModel> expenseList;
  final ValueNotifier<MapEntry<DateTime, bool>> viewOption;

  const TopExpenses({
    super.key,
    required this.expenseList,
    required this.viewOption,
  });

  @override
  Widget build(BuildContext context) {
    double sum = 0.0;
    for (final expense in expenseList) {
      sum += expense.amount;
    }

    final item = DashboardHelper.getTopExpensiveItem(expenseList);
    final category =
        DashboardHelper.getTopExpensiveCategory(expenseList, context);
    final monthOrDay = DashboardHelper.getTopExpensiveMonthOrDay(
      expenseList,
      viewOption.value.value,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Most Spent",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: _container(
                  label: viewOption.value.value ? "Day" : "Month",
                  title: monthOrDay.key,
                  amount: monthOrDay.value,
                  total: sum,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _container(
                  label: "Category",
                  title: category.key.title,
                  amount: category.value,
                  color: AppHelper.hexToColor(category.key.color),
                  total: sum,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _container(
                  label: "Item",
                  title: item.key,
                  amount: item.value,
                  total: sum,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _container({
    required String label,
    required String title,
    required double amount,
    required double total,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.blue.withOpacity(.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 60.0,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: total,
                  showLabels: false,
                  showTicks: false,
                  startAngle: 0,
                  endAngle: 360,
                  radiusFactor: .8,
                  axisLineStyle: const AxisLineStyle(
                    thickness: 0.25,
                    color: Colors.black12,
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: amount,
                      width: 0.25,
                      color: color ?? Colors.blue,
                      enableAnimation: true,
                      cornerStyle: CornerStyle.bothCurve,
                      sizeUnit: GaugeSizeUnit.factor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5.0),
          Text(
            AppHelper.amountFormatter(amount),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16.0,
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
