import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spend_wise/core/config/route/app_routes.dart';
import 'package:spend_wise/core/util/widget/zoom_animation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/asset_mapper.dart';
import '../../../../core/util/widget/custom_alert.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../account/presentation/view/my_invitation_screen.dart';
import '../../../account/presentation/widget/sign_out_dialog.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/notification_button.dart';

/// @author : Jibin K John
/// @date   : 14/11/2024
/// @time   : 17:23:51

class DecisionScreen extends StatelessWidget {
  const DecisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) => const SignOutDialog(),
          ),
          icon: Icon(Iconsax.logout_1),
        ),
        automaticallyImplyLeading: false,
        actions: [
          BlocConsumer<AuthBloc, AuthState>(
            builder: (ctx, state) {
              if (state is Authenticated) {
                return NotificationButton(userState: state);
              }
              return const SizedBox.shrink();
            },
            listener: (BuildContext context, AuthState state) {
              if (state is SigningOut) {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return CustomAlertDialog(
                        title: "Signing Out",
                        message: "",
                        actionWidget: LoadingFilledButton(
                          loading: true,
                          isDelete: true,
                          onPressed: null,
                          child: Text("Sign Out"),
                        ),
                        isLoading: true,
                      );
                    });
              }

              if (state is SignedOut) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteName.login,
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ZoomAnimationImage(
            child: SvgPicture.asset(
              AssetMapper.coinsSVG,
              height: MediaQuery.sizeOf(context).height * .4,
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(25.0),
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: AppConfig.primaryColor,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Take Control of Your Finances",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                Text(
                  "With SpendWise, managing your money is simple. Track your expenses,"
                  " set goals, and keep your spending in check, so you can save more",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, RouteName.createExpense),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppConfig.primaryColor,
                    ),
                    child: Text("Create Budget"),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MyInvitationScreen(
                          userId:
                              (context.read<AuthBloc>().state as Authenticated)
                                  .user
                                  .uid,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Join Budget"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
