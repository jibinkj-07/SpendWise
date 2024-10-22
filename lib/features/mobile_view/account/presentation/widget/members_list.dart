import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/core/util/helper/asset_mapper.dart';
import 'package:my_budget/features/mobile_view/account/presentation/view_model/account_view_model.dart';

import '../../../../common/data/model/user_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 16:38:11

class MembersList extends StatefulWidget {
  final DataSnapshot membersSnapshot;

  const MembersList({super.key, required this.membersSnapshot});

  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  final ValueNotifier<List<UserModel>> _allMembers = ValueNotifier([]);
  final ValueNotifier<bool> _loading = ValueNotifier(true);

  @override
  void initState() {
    _initMembers();
    super.initState();
  }

  @override
  void dispose() {
    _allMembers.dispose();
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _loading,
      builder: (ctx, loading, child) {
        return loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : child!;
      },
      child: ValueListenableBuilder(
        valueListenable: _allMembers,
        builder: (ctx, allMembers, child) {
          return allMembers.isEmpty
              ? const Center(child: Text("No members added yet"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  itemCount: allMembers.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: Container(
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset(AssetMapper.profileImage),
                        ),
                        title: Text(
                          allMembers[index].name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              allMembers[index].email,
                              style: const TextStyle(fontSize: 13.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Added on: ${DateFormat.yMMMd().add_jm().format(allMembers[index].addedOn!)}",
                              style: const TextStyle(fontSize: 12.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text("Delete"),
                                  content: const Text(
                                      "Are you sure want to delete this member?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(ctx);
                                        final result =
                                            await AccountViewModel.deleteMember(
                                          memberId: allMembers[index].uid,
                                          adminId: context
                                              .read<AuthBloc>()
                                              .state
                                              .userInfo!
                                              .uid,
                                        );
                                        if (result.isLeft && mounted) {
                                          result.left.showSnackBar(context);
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      child: const Text("Delete"),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Future<void> _initMembers() async {
    _allMembers.value =
        await AccountViewModel.getMembers(widget.membersSnapshot);
    _loading.value = false;
  }
}
