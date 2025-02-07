import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/asset_mapper.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../../core/util/widget/outlined_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../../domain/model/user.dart';
import '../bloc/account_bloc.dart';
import '../helper/account_helper.dart';

/// @author : Jibin K John
/// @date   : 21/11/2024
/// @time   : 15:06:03

class InviteMembersScreen extends StatefulWidget {
  final ValueNotifier<List<User>>? members;

  const InviteMembersScreen({super.key, this.members});

  @override
  State<InviteMembersScreen> createState() => _InviteMembersScreenState();
}

class _InviteMembersScreenState extends State<InviteMembersScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Iconsax.arrow_left_2),
        ),
        title: Text("Invite Member"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppHelper.horizontalPadding(size),
          vertical: 20.0,
        ),
        children: [
          // Add invite svg file here
          SvgPicture.asset(
            AssetMapper.inviteSVG,
            height: MediaQuery.sizeOf(context).height * .15,
          ),
          const SizedBox(height: 20.0),
          Form(
            key: _formKey,
            child: OutlinedTextField(
              textFieldKey: "email",
              hintText: "email",
              inputType: TextInputType.emailAddress,
              maxLength: 50,
              validator: (email) {
                final authBloc = context.read<AuthBloc>();
                String currentUserEmail = "";
                if (authBloc.state is Authenticated) {
                  currentUserEmail =
                      (authBloc.state as Authenticated).user.email;
                }
                if (email.toString().trim().isEmpty) {
                  return 'Email is empty';
                } else if (!email.toString().trim().contains('@')) {
                  return 'Provide a valid email address';
                } else if (email.toString().trim() == currentUserEmail) {
                  return "You are the admin";
                }
                return null;
              },
              onSaved: (value) => _email = value.toString().trim(),
              inputAction: TextInputAction.done,
            ),
          ),
          const SizedBox(height: 30.0),
          BlocListener<AccountBloc, AccountState>(
            listener: (ctx, state) {
              _loading.value = state is InvitingMember;

              if (state is AccountStateError) {
                state.error.showSnackBar(context);
              }

              if (state is InvitedMember) {
                Navigator.pop(context);
              }
            },
            child: ValueListenableBuilder(
              valueListenable: _loading,
              builder: (ctx, loading, _) {
                return LoadingFilledButton(
                  onPressed: _onInvite,
                  loading: loading,
                  child: Text("Invite"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onInvite() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      _loading.value = true;
      final result = await _accountHelper.getUserInfoByMail(email: _email);
      if (result.isLeft) {
        _loading.value = false;
        result.left.showSnackBar(context);
      } else {
        if (widget.members != null) {
          widget.members!.value = List.from(
            widget.members!.value..add(result.right),
          );
          Navigator.pop(context);
        } else {
          final budgetState =
              (context.read<BudgetViewBloc>().state as BudgetSubscribed);
          context.read<AccountBloc>().add(
                InviteMember(
                  memberId: result.right.uid,
                  budgetId: budgetState.budget.id,
                  budgetName: budgetState.budget.name,
                ),
              );
        }
      }
    }
  }
}
