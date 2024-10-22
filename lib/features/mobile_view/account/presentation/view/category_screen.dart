import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/route/route_mapper.dart';
import '../../../../../core/util/helper/app_helper.dart';
import '../../../../common/presentation/bloc/category_bloc.dart';
import '../../../../common/widget/category_tile.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 17:23:53

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("All Categories"),
        centerTitle: true,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (ctx, state) {
          return state.categoryList.isEmpty
              ? const Center(child: Text("No Categories"))
              : ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: state.categoryList.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: CategoryTile(
                        color: AppHelper.hexToColor(
                          state.categoryList[index].color,
                        ),
                        title: Text(
                          state.categoryList[index].title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          DateFormat.yMMMEd()
                              .add_jm()
                              .format(state.categoryList[index].createdOn),
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.black54,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: const Text("Delete"),
                                    content: const Text(
                                        "Are you sure want to delete this category?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);

                                          final authBloc = context
                                              .read<AuthBloc>()
                                              .state
                                              .userInfo;
                                          context.read<CategoryBloc>().add(
                                                DeleteCategory(
                                                  adminId: authBloc!.adminId,
                                                  categoryId: state
                                                      .categoryList[index].id,
                                                ),
                                              );
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        child: const Text("Delete"),
                                      )
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, RouteMapper.addCategory),
        icon: const Icon(Icons.add_rounded),
        label: const Text("Add Category"),
      ),
    );
  }
}
