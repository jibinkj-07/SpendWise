import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import '../../../features/common/presentation/bloc/category_bloc.dart';
import '../../../features/common/presentation/bloc/expense_bloc.dart';
import '../../../features/mobile_view/auth/presentation/bloc/auth_bloc.dart';
import '../injection/injection_container.dart';

sealed class BlocProviders {
  static List<SingleChildWidget> get list => [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<ExpenseBloc>(create: (_) => sl<ExpenseBloc>()),
        BlocProvider<CategoryBloc>(create: (_) => sl<CategoryBloc>()),
      ];
}
