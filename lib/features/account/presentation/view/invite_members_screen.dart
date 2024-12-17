import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../../core/util/widget/outlined_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/model/user.dart';
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
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          "Invite Member",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppHelper.horizontalPadding(size),
          vertical: 20.0,
        ),
        children: [
          //todo
          // Add invite svg file here
          Form(
            key: _formKey,
            child: OutlinedTextField(
              textFieldKey: "email",
              hintText: "email",
              inputType: TextInputType.emailAddress,
              maxLength: 50,
              validator: (email) {
                if (email.toString().trim().isEmpty) {
                  return 'Email is empty';
                } else if (!email.toString().trim().contains('@')) {
                  return 'Provide a valid email address';
                } else if (email.toString().trim() ==
                    context.read<AuthBloc>().state.currentUser?.email) {
                  return "You are the admin";
                }
                return null;
              },
              onSaved: (value) => _email = value.toString().trim(),
              inputAction: TextInputAction.done,
            ),
          ),
          const SizedBox(height: 30.0),
          ValueListenableBuilder(
            valueListenable: _loading,
            builder: (ctx, loading, _) {
              return LoadingFilledButton(
                onPressed: _onInvite,
                loading: loading,
                child: Text("Invite"),
              );
            },
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
        } else {
          // call invite member function
        }
        Navigator.pop(context);
      }
    }
  }
}
