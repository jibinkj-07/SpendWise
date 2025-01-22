import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/asset_mapper.dart';
import '../../../budget/domain/model/budget_model.dart';
import '../widgets/budget_switcher.dart';

/// @author : Jibin K John
/// @date   : 15/01/2025
/// @time   : 12:33:34

class ErrorScreen extends StatelessWidget {
  final Failure error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Budget Error"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(
          AppHelper.horizontalPadding(size),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              AssetMapper.errorSVG,
              height: size.height * .3,
            ),
            Column(
              children: [
                Text(
                  error.message,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                FilledButton(
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (ctx) => BudgetSwitcher(
                          currentIndex: 0,
                          budgetDetail: BudgetModel.dummy(),
                          fromRequestedScreen: false,
                        ),
                      );
                    },
                    child: Text("Switch Budget")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
