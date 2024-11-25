import 'dart:ui';

import '../../../budget/domain/model/category_model.dart';


sealed class CategoryHelper {
  static List<CategoryModel> suggestionCategories() => [
        CategoryModel(
          id: "food",
          name: "Food",
          color: Color(0xFFFF9800),
          icon: "fastfood",
          createdOn: DateTime.now(),
          createdBy: "",
        ),
        CategoryModel(
          id: "transportation",
          name: "Transportation",
          color: Color(0xFF2196F3),
          icon: "directions_bus",
          createdOn: DateTime.now(),
          createdBy: "",
        ),
        CategoryModel(
          id: "groceries",
          name: "Groceries",
          color: Color(0xFFE91E63),
          icon: "local_grocery_store",
          createdOn: DateTime.now(),
          createdBy: "",
        ),
        CategoryModel(
          id: "housing",
          name: "Housing",
          color: Color(0xFF795548),
          icon: "house",
          createdOn: DateTime.now(),
          createdBy: "",
        ),
        CategoryModel(
          id: "utilities",
          name: "Utilities",
          color: Color(0xFF03A9F4),
          icon: "lightbulb",
          createdOn: DateTime.now(),
          createdBy: "",
        ),
        CategoryModel(
          id: "entertainment",
          name: "Entertainment",
          color: Color(0xFF9C27B0),
          icon: "sports_esports",
          createdOn: DateTime.now(),
          createdBy: "",
        ),
        CategoryModel(
          id: "health",
          name: "Health & Fitness",
          color: Color(0xFFF44336),
          icon: "volunteer_activism",
          createdOn: DateTime.now(),
          createdBy: "",
        ),
        CategoryModel(
          id: "education",
          name: "Education",
          color: Color(0xFF009688),
          icon: "school",
          createdOn: DateTime.now(),
          createdBy: "",
        ),
        CategoryModel(
          id: "travel",
          name: "Travel",
          color: Color(0xFF00BCD4),
          icon: "flight",
          createdOn: DateTime.now(),
          createdBy: "",
        ),
        CategoryModel(
          id: "miscellaneous",
          name: "Miscellaneous",
          color: Color(0xFF9E9E9E),
          icon: "attach_money",
          createdOn: DateTime.now(),
          createdBy: "",
        ),
      ];
}
