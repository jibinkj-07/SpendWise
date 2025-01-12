import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../budget/presentation/bloc/category_view_bloc.dart';
import '../bloc/transaction_bloc.dart';

/// @author : Jibin K John
/// @date   : 12/01/2025
/// @time   : 17:06:32

class TopBar extends StatelessWidget {
  final Size size;
  final String selectedCategoryId;
  final ValueNotifier<String> searchQuery;

  const TopBar({
    super.key,
    required this.size,
    required this.selectedCategoryId,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      color: Colors.white,
      child: Column(
        children: [
          // Search box
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: AppHelper.horizontalPadding(size),
            ),
            child: TextField(
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
                hintText: "Search with \"Title\" or \"Amount\"",
                hintStyle: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (query) => searchQuery.value = query.trim(),
            ),
          ),
          // Category filters
          BlocBuilder<CategoryViewBloc, CategoryViewState>(
              builder: (ctx, state) {
            if (state is CategorySubscribed && state.categories.isNotEmpty) {
              return SizedBox(
                height: size.height * .05,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppHelper.horizontalPadding(size),
                  ),
                  itemCount: state.categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    final isSelected =
                        state.categories[index].id == selectedCategoryId;
                    return Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: ActionChip(
                        onPressed: () {
                          context.read<TransactionBloc>().add(
                                UpdateCategory(
                                    categoryId: state.categories[index].id),
                              );
                        },
                        side: BorderSide.none,
                        backgroundColor:
                            isSelected ? Colors.blue.shade50 : Colors.grey.shade200,
                        label: Text(
                          state.categories[index].name,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: isSelected?Colors.blue:Colors.black,
                            fontWeight:isSelected?FontWeight.w500: FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
