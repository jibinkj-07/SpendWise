import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/util/extension/string_ext.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../bloc/analysis_bloc.dart';

/// @author : Jibin K John
/// @date   : 03/01/2025
/// @time   : 21:48:03

class ViewSwitcher extends StatelessWidget {
  final Size size;
  final AnalyticsFilter filter;

  const ViewSwitcher({
    super.key,
    required this.size,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppHelper.horizontalPadding(size),
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: AnalyticsFilter.values.map((item) {
          final isSelected = filter == item;
          // return OutlinedButton(onPressed: (){}, child: Text(item.name));
          return Expanded(
            child: GestureDetector(
              onTap: () => context.read<AnalysisBloc>().add(
                    UpdateAnalysisFilter(analyticsFilter: item),
                  ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade50 : Colors.transparent,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Text(
                  item.name.firstLetterToUpperCase(),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.blue : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
