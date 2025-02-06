import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../bloc/analysis_bloc.dart';
import '../helper/analysis_helper.dart';

sealed class BottomDatePicker {
  static void showDialog(BuildContext context) {
    final analysisBloc = context.read<AnalysisBloc>().state;
    final List<String> values = _getPickerValues(
      analysisBloc.filter,
      analysisBloc.date,
    );
    DateTime selectedDate = analysisBloc.date;
    int weekNumber = analysisBloc.weekNumber;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.sizeOf(context).height * .35,
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 45.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: _getIndex(
                      analysisBloc.date,
                      analysisBloc.filter,
                      analysisBloc.weekNumber,
                      values,
                    ),
                  ),
                  onSelectedItemChanged: (index) {
                    switch (analysisBloc.filter) {
                      case AnalyticsFilter.week:
                        {
                          weekNumber = (int.parse(values[index].split(" ").last))-1;
                          break;
                        }
                      case AnalyticsFilter.month:
                        {
                          selectedDate = DateTime(selectedDate.year, index + 1);
                          weekNumber = 1;
                          break;
                        }
                      case AnalyticsFilter.year:
                        {
                          selectedDate = DateTime(int.parse(values[index]));
                          weekNumber = 1;
                          break;
                        }
                    }
                  },
                  children:
                      values.map((item) => Center(child: Text(item))).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                    ),
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<AnalysisBloc>().add(
                            UpdateDate(
                              date: selectedDate,
                              budgetId: (context.read<BudgetViewBloc>().state
                                      as BudgetSubscribed)
                                  .budget
                                  .id,
                              weekNumber: weekNumber,
                            ),
                          );
                    },
                    child: Text("Done"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static List<String> _getPickerValues(
    AnalyticsFilter filter,
    DateTime currentDateTime,
  ) {
    switch (filter) {
      case AnalyticsFilter.week:
        return List.generate(
            AnalysisHelper.getTotalWeeksInMonth(
              currentDateTime.year,
              currentDateTime.month,
            ),
            (index) => "Week ${index + 1}");
      case AnalyticsFilter.month:
        return [
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December",
        ];
      case AnalyticsFilter.year:
        {
          int currentYear = DateTime.now().year;
          List<String> years = [];
          for (int year = 2023; year <= currentYear; year++) {
            years.add(year.toString());
          }
          return years;
        }
    }
  }

  static int _getIndex(
    DateTime date,
    AnalyticsFilter filter,
    int weekNumber,
    List<String> values,
  ) {
    switch (filter) {
      case AnalyticsFilter.week:
        return weekNumber;
      case AnalyticsFilter.month:
        return date.month - 1;
      case AnalyticsFilter.year:
        return values.indexOf(date.year.toString());
    }
  }
}
