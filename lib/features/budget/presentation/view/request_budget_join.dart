import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spend_wise/core/util/constant/constants.dart';

import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/asset_mapper.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../../core/util/widget/outlined_text_field.dart';
import '../../../../root.dart';
import '../../../account/presentation/bloc/account_bloc.dart';
import '../../../account/presentation/helper/account_helper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 22/01/2025
/// @time   : 19:16:25

class RequestBudgetJoin extends StatefulWidget {
  const RequestBudgetJoin({super.key});

  @override
  State<RequestBudgetJoin> createState() => _RequestBudgetJoinState();
}

class _RequestBudgetJoinState extends State<RequestBudgetJoin> {
  final _formKey = GlobalKey<FormState>();
  String _budgetId = "";
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final AccountHelper _accountHelper = sl<AccountHelper>();

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Request"),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: AppHelper.horizontalPadding(size),
          vertical: 10.0,
        ),
        children: [
          SvgPicture.asset(
            AssetMapper.requestSVG,
            height: size.height * .2,
          ),
          const SizedBox(height: 10.0),
          Text(
            "A Budget ID looks like this:\n23******-****-****-****-*********d39\n"
            "\nIt is a unique identifier for a budget."
            " You can obtain a Budget ID if a member of the budget shares it with you.\n"
            "Ensure you copy it exactly as provided to join or manage the budget.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Form(
            key: _formKey,
            child: OutlinedTextField(
              textFieldKey: "Budget ID",
              hintText: "Budget ID",
              inputType: TextInputType.emailAddress,
              maxLength: 50,
              validator: (id) {
                if (id.toString().trim().isEmpty) {
                  return 'Budget ID is empty';
                } else if (id.toString().trim().contains('@')) {
                  return 'Provide a valid id';
                }
                return null;
              },
              onSaved: (value) => _budgetId = value.toString().trim(),
              inputAction: TextInputAction.done,
            ),
          ),
          const SizedBox(height: 30.0),
          BlocListener<AccountBloc, AccountState>(
            listener: (ctx, state) {
              _loading.value = state is Requesting;
              if (state is AccountStateError) {
                state.error.showSnackBar(context);
              }

              if (state is Requested) {
                // Navigator.of(context).pushAndRemoveUntil(
                //   MaterialPageRoute(
                //     builder: (_) => Root(
                //       userId: (context.read<AuthBloc>().state as Authenticated)
                //           .user
                //           .uid,
                //       budgetId: kRequested,
                //     ),
                //   ),
                //   (_) => false,
                // );
              }
            },
            child: ValueListenableBuilder(
              valueListenable: _loading,
              builder: (ctx, loading, _) {
                return LoadingFilledButton(
                  onPressed: _onRequest,
                  loading: loading,
                  child: Text("Send Request"),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      final authBloc = (context.read<AuthBloc>().state as Authenticated);
      context.read<AccountBloc>().add(
            RequestAccess(
              memberId: authBloc.user.uid,
              budgetId: _budgetId,
              memberName: authBloc.user.name,
            ),
          );
    }
  }
}
