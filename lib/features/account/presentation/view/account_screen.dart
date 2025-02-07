import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../widget/leave_alert_dialog.dart';
import '../widget/profile_info.dart';
import '../widget/sign_out_dialog.dart';
import 'budget_detail_screen.dart';
import 'members_screen.dart';
import 'my_invitation_screen.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 15:31:03

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState state) => PopScope(
        canPop: state is! SigningOut,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: state is SigningOut
                ? null
                : IconButton(
                    icon: const Icon(Iconsax.arrow_left_2),
                    onPressed: () => Navigator.pop(context),
                  ),
            title: const Text("My Account"),
            centerTitle: true,
          ),
          body: state is Authenticated
              ? ListView(
                  padding: EdgeInsets.all(AppHelper.horizontalPadding(size)),
                  children: [
                    ProfileInfo(size: size, user: state.user),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300, blurRadius: 5.0),
                        ],
                        color: Colors.white,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: BlocBuilder<BudgetViewBloc, BudgetViewState>(
                            builder: (ctx, budgetState) {
                          return Column(
                            children: [
                              if (budgetState is BudgetSubscribed) ...[
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => BudgetDetailScreen(
                                          userId: state.user.uid,
                                          budget: budgetState.budget,
                                        ),
                                      ),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.0),
                                    ),
                                  ),
                                  leading: Icon(Iconsax.wallet_money),
                                  title: Text("Budget"),
                                  subtitle: Text(
                                      "Find more details about current budget"),
                                  trailing: Icon(
                                    Iconsax.arrow_right_3,
                                    size: 15.0,
                                    color: AppConfig.primaryColor,
                                  ),
                                ),
                                if (budgetState.budget.admin != state.user.uid)
                                  ListTile(
                                    onTap: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (ctx) => LeaveAlertDialog(
                                          budgetId: budgetState.budget.id,
                                          budgetName: budgetState.budget.name,
                                          userId: state.user.uid,
                                          userName: state.user.name,
                                        ),
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.0),
                                      ),
                                    ),
                                    leading: Icon(Iconsax.box_remove),
                                    title: Text("Leave Budget"),
                                    subtitle: Text(
                                        "Delete and leave from current budget"),
                                    trailing: Icon(
                                      Iconsax.arrow_right_3,
                                      size: 15.0,
                                      color: AppConfig.primaryColor,
                                    ),
                                  ),
                                // ListTile(
                                //   onTap: () {},
                                //   leading: Icon(Iconsax.edit_document),
                                //   title: Text("Generate Report"),
                                //   subtitle:
                                //       Text("Generate report for a specific month"),
                                //   trailing: Icon(
                                //     Iconsax.arrow_right_3,
                                //     size: 15.0,
                                //     color: AppConfig.primaryColor,
                                //   ),
                                // ),
                                if (budgetState.budget.admin == state.user.uid)
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => MembersScreen(
                                            adminId: budgetState.budget.admin,
                                            budgetName: budgetState.budget.name,
                                            budgetId: budgetState.budget.id,
                                          ),
                                        ),
                                      );
                                    },
                                    leading: Icon(Iconsax.people),
                                    title: Text("Members"),
                                    subtitle:
                                        Text("Manage your budget members"),
                                    trailing: Icon(
                                      Iconsax.arrow_right_3,
                                      size: 15.0,
                                      color: AppConfig.primaryColor,
                                    ),
                                  ),
                              ],
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => MyInvitationScreen(
                                        userId: state.user.uid,
                                      ),
                                    ),
                                  );
                                },
                                leading: Icon(Iconsax.direct_inbox),
                                title: Text("Invitations"),
                                subtitle:
                                    Text("Manage your budget invitations"),
                                trailing: Icon(
                                  Iconsax.arrow_right_3,
                                  size: 15.0,
                                  color: AppConfig.primaryColor,
                                ),
                              ),
                              ListTile(
                                onTap: () => showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (ctx) => const SignOutDialog(),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20.0),
                                  ),
                                ),
                                leading: Icon(
                                  Iconsax.logout_1,
                                  color: AppConfig.errorColor,
                                ),
                                title: Text(
                                  "Sign Out",
                                  style: TextStyle(
                                    color: AppConfig.errorColor,
                                  ),
                                ),
                                trailing: Icon(
                                  Iconsax.arrow_right_3,
                                  size: 15.0,
                                  color: AppConfig.errorColor,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Version ${AppConfig.version}",
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
