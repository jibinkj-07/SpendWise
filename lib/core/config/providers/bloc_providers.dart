import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/budget/presentation/bloc/budget_bloc.dart';
import '../../../features/budget/presentation/bloc/category_bloc.dart';
import '../injection/injection_container.dart';

sealed class BlocProviders {
  static List<SingleChildWidget> get list => [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<BudgetBloc>(create: (_) => sl<BudgetBloc>()),
        BlocProvider<CategoryBloc>(create: (_) => sl<CategoryBloc>()),
      ];
}
