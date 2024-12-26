import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/helper/asset_mapper.dart';
import '../bloc/auth_bloc.dart';
import '../widget/auth_bg.dart';
import 'package:lottie/lottie.dart';

/// @author : Jibin K John
/// @date   : 26/12/2024
/// @time   : 20:54:11

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBg(
      title: "Network Lost",
      formKey: GlobalKey<FormState>(),
      children: [
        Center(
          child: Lottie.asset(
            AssetMapper.noInternetLottie,
            height: MediaQuery.sizeOf(context).height * .3,
          ),
        ),
        const SizedBox(height: 15.0),
        Center(
          child: Text(
            "Connect to a stable network",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Center(
          child: FilledButton(
              onPressed: () {
                context.read<AuthBloc>().add(InitUser());
                Navigator.pushReplacementNamed(context, RouteName.root);
              },
              child: Text("Try Again")),
        ),
      ],
    );
  }
}
