import 'package:flutter/material.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../data/model/goal_model.dart';

/// @author : Jibin K John
/// @date   : 24/10/2024
/// @time   : 18:11:54

class GoalChart extends StatelessWidget {
  final GoalModel model;

  const GoalChart({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final totalAmount = model.transactions.fold(
      0.0,
      (previousValue, transaction) => previousValue + transaction.amount,
    );
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: model.budget,
          showLabels: false,
          showTicks: false,
          startAngle: 0,
          endAngle: 360,
          radiusFactor: 0.8,
          axisLineStyle: AxisLineStyle(
            thickness: 0.2,
            color: Colors.blue.shade50,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: totalAmount > model.budget ? model.budget : totalAmount,
              width: 0.2,
              gradient: SweepGradient(
                colors: [
                  Colors.cyan.shade300,
                  Colors.cyan,
                  Colors.blue.shade300,
                  Colors.blue,
                  Colors.blue.shade700,
                ],
              ),
              enableAnimation: true,
              cornerStyle: CornerStyle.bothCurve,
              sizeUnit: GaugeSizeUnit.factor,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    AppHelper.amountFormatter(totalAmount),
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "of ${AppHelper.amountFormatter(model.budget)}",
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              angle: 90,
              positionFactor: 0,
            ),
          ],
        ),
      ],
    );
  }
}
