import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/config/route/route_mapper.dart';
import 'package:my_budget/core/util/helper/firebase_mapper.dart';
import 'package:my_budget/core/util/mixin/validation_mixin.dart';
import 'package:my_budget/features/mobile_view/account/presentation/widget/members_list.dart';

import '../../../../../core/util/widgets/loading_button.dart';
import '../../../../../core/util/widgets/outlined_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/util/auth_helper.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 15:33:42

class ManageAccessScreen extends StatefulWidget {
  const ManageAccessScreen({super.key});

  @override
  State<ManageAccessScreen> createState() => _ManageAccessScreenState();
}

class _ManageAccessScreenState extends State<ManageAccessScreen>
    with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  String _email = "";

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Manage Access"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref(
              FirebaseMapper.memberPath(
                context.read<AuthBloc>().state.userInfo!.uid,
              ),
            )
            .onValue,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.snapshot.value == null) {
              return const Center(
                child: Text("No members added yet"),
              );
            }
            return MembersList(membersSnapshot: snapshot.data!.snapshot);
          }
          return const Center(
            child: Text("No members added yet"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, RouteMapper.addMember),
        icon: const Icon(Icons.add_rounded),
        label: const Text("Add Member"),
      ),
    );
  }
}
