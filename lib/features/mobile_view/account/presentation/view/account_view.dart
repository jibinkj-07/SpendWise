import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/config/route/route_mapper.dart';
import 'package:my_budget/core/constants/app_constants.dart';
import 'package:my_budget/core/util/helper/asset_mapper.dart';
import 'package:my_budget/core/util/widgets/loading_button.dart';

import '../../../../../core/util/helper/app_helper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 20:17:07

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    bool isAdmin = false;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (ctx, state) {
        _loading.value = state.authStatus == AuthStatus.signingOut;
        if (state.error != null) {
          state.error!.showSnackBar(context);
        }

        if (state.userInfo == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteMapper.login,
            (route) => false,
          );
        }
      },
      builder: (BuildContext context, AuthState state) {
        isAdmin = state.userInfo!.adminId == state.userInfo!.uid;
        if (state.userInfo != null) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            children: [
              Container(
                width: size.width * .4,
                height: size.width * .4,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Image.asset(AssetMapper.profileImage),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  state.userInfo!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Center(
                child: Text(
                  state.userInfo!.email,
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12, width: .5),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 35.0),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      if (state.userInfo!.adminId.isEmpty)
                        ListTile(
                          onTap: () =>
                              AppHelper.sendAccessRequestEmail(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          leading: const Icon(Icons.mail_rounded),
                          title: const Text("Request Access"),
                          subtitle: const Text(
                            "Send mail to gain access",
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.blue,
                            size: 20.0,
                          ),
                        )
                      else ...[
                        if (isAdmin)
                          ListTile(
                            onTap: () => Navigator.of(context)
                                .pushNamed(RouteMapper.manageAccess),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                            ),
                            leading:
                                const Icon(Icons.admin_panel_settings_rounded),
                            title: const Text("Manage Access"),
                            subtitle: const Text(
                              "Manage your members access",
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.blue,
                              size: 20.0,
                            ),
                          ),
                        ListTile(
                          onTap: () => Navigator.of(context)
                              .pushNamed(RouteMapper.categoryScreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: isAdmin
                                  ? Radius.zero
                                  : const Radius.circular(15.0),
                              topRight: isAdmin
                                  ? Radius.zero
                                  : const Radius.circular(15.0),
                              bottomLeft: const Radius.circular(15.0),
                              bottomRight: const Radius.circular(15.0),
                            ),
                          ),
                          leading: const Icon(Icons.category_rounded),
                          title: const Text("Category"),
                          subtitle: const Text(
                            "Manage your category list",
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.blue,
                            size: 20.0,
                          ),
                        ),
                      ],
                      if (state.userInfo!.email == AppConstants.kAppSupportMail)
                        ListTile(
                          onTap: () => Navigator.of(context)
                              .pushNamed(RouteMapper.userAccess),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          leading: const Icon(Icons.security_rounded),
                          title: const Text("User Access"),
                          subtitle: const Text(
                            "Manage SpendWise access for users",
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.blue,
                            size: 20.0,
                          ),
                        )
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _loading,
                builder: (ctx, loading, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: LoadingButton(
                      onPressed: () => context.read<AuthBloc>().add(SignOut()),
                      loading: loading,
                      loadingLabel: "Signing out",
                      child: const Text("Sign Out"),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10.0),
              Center(child: Text("Version ${AppConstants.kAppVersion}")),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
