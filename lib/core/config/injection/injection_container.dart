import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/budget/presentation/bloc/category_bloc.dart';
import '../../../features/home/presentation/bloc/home_transaction_bloc.dart';
import './imports.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // **************************************** Class ****************************************
  sl.registerLazySingleton<AccountHelper>(() => AccountHelper(sl(), sl()));
  sl.registerLazySingleton<HomeHelper>(() => HomeHelper(sl()));

  // **************************************** Externals ****************************************
  final auth = FirebaseAuth.instance;
  final googleAuth = GoogleSignIn();
  final db = FirebaseDatabase.instance;
  final storage = FirebaseStorage.instance;
  final sharedPref = await SharedPreferences.getInstance();

  sl.registerLazySingleton<GoogleSignIn>(() => googleAuth);
  sl.registerLazySingleton<FirebaseAuth>(() => auth);
  sl.registerLazySingleton<FirebaseDatabase>(() => db);
  sl.registerLazySingleton<FirebaseStorage>(() => storage);
  sl.registerLazySingleton<SharedPreferences>(() => sharedPref);

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
  sl.registerSingleton<BudgetBloc>(BudgetBloc(sl(), sl()));
  sl.registerSingleton<CategoryBloc>(CategoryBloc(sl(), sl()));
  sl.registerSingleton<HomeTransactionBloc>(HomeTransactionBloc(sl(), sl()));
}
