import '../../../features/common/data/data_source/expense_fb_data_source.dart';
import '../../../features/common/data/repo/expense_repo_impl.dart';
import '../../../features/common/domain/repo/expense_repo.dart';
import '../../../features/common/presentation/bloc/expense_bloc.dart';
import './imports.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // **************************************** Externals ****************************************
  final auth = FirebaseAuth.instance;
  final db = FirebaseDatabase.instance;
  final storage = FirebaseStorage.instance;

  sl.registerLazySingleton<FirebaseAuth>(() => auth);
  sl.registerLazySingleton<FirebaseDatabase>(() => db);
  sl.registerLazySingleton<FirebaseStorage>(() => storage);

  // **************************************** Data Sources ****************************************

  sl.registerLazySingleton<AuthFbDataSource>(
      () => AuthFbDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<ExpenseFbDataSource>(
      () => ExpenseFbDataSourceImpl(sl(), sl(), sl()));

  // **************************************** Repos ****************************************
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));
  sl.registerLazySingleton<ExpenseRepo>(() => ExpenseRepoImpl(sl()));

  // **************************************** Bloc ****************************************
  sl.registerSingleton<AuthBloc>(AuthBloc(sl(), sl()));
  sl.registerSingleton<ExpenseBloc>(ExpenseBloc(sl()));
}
