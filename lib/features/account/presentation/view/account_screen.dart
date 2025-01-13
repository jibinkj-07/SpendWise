import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widget/display_image.dart';
import '../widget/profile_info.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 15:31:03

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("My Account"),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (ctx, state) {
          if (state is Authenticated) {
            return ListView(
              padding: EdgeInsets.all(AppHelper.horizontalPadding(size)),
              children: [
                ProfileInfo(size: size, user: state.user),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade300, blurRadius: 5.0),
                    ],
                    color: Colors.white,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0),
                            ),
                          ),
                          leading: Icon(Icons.account_balance_rounded),
                          title: Text("My Budget"),
                          subtitle:
                              Text("Find more details about current budget"),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 15.0,
                            color: AppConfig.primaryColor,
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0),
                            ),
                          ),
                          leading: Icon(Icons.edit_document),
                          title: Text("Generate Report"),
                          subtitle:
                              Text("Generate report for a specific month"),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 15.0,
                            color: AppConfig.primaryColor,
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0),
                            ),
                          ),
                          leading: Icon(Icons.people_alt_rounded),
                          title: Text("Members"),
                          subtitle: Text("Edit or view your budget members"),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 15.0,
                            color: AppConfig.primaryColor,
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0),
                            ),
                          ),
                          leading: Icon(Icons.link_rounded),
                          title: Text("Invitations"),
                          subtitle:
                              Text("Manage or view your budget invitations"),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 15.0,
                            color: AppConfig.primaryColor,
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20.0),
                            ),
                          ),
                          leading: Icon(
                            Icons.logout_rounded,
                            color: AppConfig.errorColor,
                          ),
                          title: Text(
                            "Sign Out",
                            style: TextStyle(
                              color: AppConfig.errorColor,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 15.0,
                            color: AppConfig.errorColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Version ${AppConfig.version}",
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
