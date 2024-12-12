import '../../../features/account/presentation/helper/account_helper.dart';
import '../../../features/budget/presentation/bloc/budget_bloc.dart';
import '../../../features/budget/presentation/bloc/category_bloc.dart';
import '../../../features/budget/presentation/helper/budget_helper.dart';
import '../../../features/home/presentation/helper/home_helper.dart';
import './imports.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // **************************************** Class ****************************************
  sl.registerLazySingleton<AccountHelper>(() => AccountHelper(sl(), sl()));
  sl.registerLazySingleton<BudgetHelper>(() => BudgetHelper(sl()));
  sl.registerLazySingleton<HomeHelper>(() => HomeHelper(sl()));

  // **************************************** Externals ****************************************
  final auth = FirebaseAuth.instance;
  final googleAuth = GoogleSignIn();
  final db = FirebaseDatabase.instance;
  final storage = FirebaseStorage.instance;

  sl.registerLazySingleton<GoogleSignIn>(() => googleAuth);
  sl.registerLazySingleton<FirebaseAuth>(() => auth);
  sl.registerLazySingleton<FirebaseDatabase>(() => db);
  sl.registerLazySingleton<FirebaseStorage>(() => storage);

  // **************************************** Data Sources ****************************************

  sl.registerLazySingleton<AuthFbDataSource>(
    () => AuthFbDataSourceImpl(
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<BudgetFbDataSource>(
      () => BudgetFbDataSourceImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<AccountFbDataSource>(
      () => AccountFbDataSourceImpl(sl()));

  // **************************************** Repos ****************************************
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));
  sl.registerLazySingleton<BudgetRepo>(() => BudgetRepoImpl(sl()));
  sl.registerLazySingleton<AccountRepo>(() => AccountRepoImpl(sl()));

  // **************************************** Bloc ****************************************
  sl.registerSingleton<AuthBloc>(AuthBloc(sl()));
  sl.registerSingleton<BudgetBloc>(BudgetBloc(sl()));
  sl.registerSingleton<CategoryBloc>(CategoryBloc(sl()));
}
