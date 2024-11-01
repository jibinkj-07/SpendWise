import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/constants/app_constants.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/features/common/data/model/category_model.dart';
import 'package:my_budget/features/mobile_view/account/presentation/view/category_add_screen.dart';

import '../../../../common/presentation/bloc/category_bloc.dart';
import '../../../../common/widget/category_tile.dart';

/// @author : Jibin K John
/// @date   : 21/10/2024
/// @time   : 14:07:39

class BottomCategorySheet extends StatefulWidget {
  const BottomCategorySheet({super.key});

  @override
  State<BottomCategorySheet> createState() => _BottomCategorySheetState();
}

class _BottomCategorySheetState extends State<BottomCategorySheet> {
  List<CategoryModel> allCategory = [];
  late List<CategoryModel> filteredItems;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _initCategory();
    super.initState();
  }

  void _initCategory() {
    log("called");
    allCategory = List.from(context.read<CategoryBloc>().state.categoryList);
    setState(() {
      filteredItems = allCategory;
    });
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = allCategory;
      } else {
        filteredItems = allCategory
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CategoryAddScreen(
                                    refreshData: _initCategory),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppConstants.kAppColor,
                          ),
                          child: const Text(
                            "Add",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onChanged: _filterItems,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(
                        child: Text("Category not found"),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CategoryTile(
                              height: 45.0,
                              color: AppHelper.hexToColor(
                                filteredItems[index].color,
                              ),
                              title: Text(
                                filteredItems[index].title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context, filteredItems[index]);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
