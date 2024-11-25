
import './imports.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // **************************************** Class ****************************************
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
}
