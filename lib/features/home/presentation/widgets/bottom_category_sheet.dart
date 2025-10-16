import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/empty.dart';
import '../../../budget/domain/model/category_model.dart';
import '../../../budget/presentation/bloc/category_view_bloc.dart';

/// @author : Jibin K John
/// @date   : 20/12/2024
/// @time   : 18:56:26

class BottomCategorySheet extends StatefulWidget {
  const BottomCategorySheet({super.key});

  @override
  State<BottomCategorySheet> createState() => _BottomCategorySheetState();
}

class _BottomCategorySheetState extends State<BottomCategorySheet> {
  List<CategoryModel> _categories = [];
  final ValueNotifier<String> _searchQuery = ValueNotifier("");
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchQuery.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryViewBloc, CategoryViewState>(
      builder: (ctx, state) {
        if (state is CategorySubscribed) {
          return ValueListenableBuilder(
              valueListenable: _searchQuery,
              builder: (ctx, query, _) {
                if (query.trim().isEmpty) {
                  _categories = List.from(state.categories);
                } else {
                  _categories = state.categories
                      .where((item) => item.name.toLowerCase().contains(
                            query.toLowerCase(),
                          ))
                      .toList();
                }
                return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.5,
                  minChildSize: 0.5,
                  maxChildSize: 0.9,
                  builder: (
                    BuildContext context,
                    ScrollController scrollController,
                  ) {
                    return Container(
                      padding: const EdgeInsets.all(15.0),
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.black54,
                                      ),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pushNamed(
                                          RouteName.createCategory,
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppConfig.primaryColor,
                                      ),
                                      child: const Text(
                                        "Create",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                TextField(
                                  controller: _searchController,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 0.0,
                                    ),
                                    fillColor: Colors.grey.shade200,
                                    filled: true,
                                    hintText: "Search Categories",
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onChanged: (query) =>
                                      _searchQuery.value = query,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: _categories.isEmpty
                                ? const Empty(message: "Category not found")
                                : GridView.builder(
                                    controller: scrollController,
                                    itemCount: _categories.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        onTap: () => Navigator.pop(
                                            context, _categories[index]),
                                        leading: CircleAvatar(
                                          radius: 15.0,
                                          backgroundColor: _categories[index]
                                              .color
                                              .withValues(alpha: .15),
                                          child: Icon(
                                            AppHelper.getIconFromString(
                                              _categories[index].icon,
                                            ),
                                            size: 20.0,
                                            color: _categories[index].color,
                                          ),
                                        ),
                                        title: Text(
                                          _categories[index].name,
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      );
                                    },
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5.0,
                                      childAspectRatio: 1 / .35,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              });
        }
        return const SizedBox.shrink();
      },
    );
  }
}
