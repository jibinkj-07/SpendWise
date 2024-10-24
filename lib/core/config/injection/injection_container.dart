
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
  sl.registerLazySingleton<CategoryFbDataSource>(
      () => CategoryFbDataSourceImpl(sl()));
  sl.registerLazySingleton<GoalFbDataSource>(
      () => GoalFbDataSourceImpl(sl(),sl()));

  // **************************************** Repos ****************************************
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));
  sl.registerLazySingleton<ExpenseRepo>(() => ExpenseRepoImpl(sl()));
  sl.registerLazySingleton<CategoryRepo>(() => CategoryRepoImpl(sl()));
  sl.registerLazySingleton<GoalRepo>(() => GoalRepoImpl(sl()));

  // **************************************** Bloc ****************************************
  sl.registerSingleton<AuthBloc>(AuthBloc(sl(), sl()));
  sl.registerSingleton<ExpenseBloc>(ExpenseBloc(sl()));
  sl.registerSingleton<CategoryBloc>(CategoryBloc(sl()));
  sl.registerSingleton<GoalBloc>(GoalBloc(sl()));
}
