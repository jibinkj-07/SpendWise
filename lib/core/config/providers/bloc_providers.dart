import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/budget/presentation/bloc/budget_edit_bloc.dart';
import '../../../features/budget/presentation/bloc/budget_view_bloc.dart';
import '../../../features/budget/presentation/bloc/category_edit_bloc.dart';
import '../../../features/budget/presentation/bloc/category_view_bloc.dart';
import '../../../features/transactions/presentation/bloc/month_trans_view_bloc.dart';
import '../../../features/transactions/presentation/bloc/transaction_edit_bloc.dart';
import '../injection/injection_container.dart';

sealed class BlocProviders {
  static List<SingleChildWidget> get list => [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<BudgetViewBloc>(create: (_) => sl<BudgetViewBloc>()),
        BlocProvider<BudgetEditBloc>(create: (_) => sl<BudgetEditBloc>()),
        BlocProvider<MonthTransViewBloc>(
            create: (_) => sl<MonthTransViewBloc>()),
        BlocProvider<TransactionEditBloc>(
            create: (_) => sl<TransactionEditBloc>()),
        BlocProvider<CategoryViewBloc>(create: (_) => sl<CategoryViewBloc>()),
        BlocProvider<CategoryEditBloc>(create: (_) => sl<CategoryEditBloc>()),
      ];
}
