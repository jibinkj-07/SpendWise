import './imports.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // **************************************** Class ****************************************
  sl.registerLazySingleton<AccountHelper>(() => AccountHelper(sl()));
  sl.registerLazySingleton<HomeHelper>(() => HomeHelper(sl()));
  sl.registerLazySingleton<NotificationHelper>(() => NotificationHelper(sl()));
  sl.registerLazySingleton<NotificationFbHelper>(
      () => NotificationFbHelper(sl()));
  sl.registerLazySingleton<SharedPrefHelper>(() => SharedPrefHelper(sl()));

  // **************************************** Externals ****************************************
  final auth = FirebaseAuth.instance;
  final googleAuth = GoogleSignIn();
  final db = FirebaseDatabase.instance;
  final storage = FirebaseStorage.instance;
  final localStorage = await SharedPreferences.getInstance();

  sl.registerLazySingleton<GoogleSignIn>(() => googleAuth);
  sl.registerLazySingleton<FirebaseAuth>(() => auth);
  sl.registerLazySingleton<FirebaseDatabase>(() => db);
  sl.registerLazySingleton<FirebaseStorage>(() => storage);
  sl.registerLazySingleton<SharedPreferences>(() => localStorage);

  // **************************************** Data Sources ****************************************

  sl.registerLazySingleton<AuthFbDataSource>(
    () => AuthFbDataSourceImpl(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<BudgetFbDataSource>(() => BudgetFbDataSourceImpl(
        sl(),
        sl(),
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<AccountFbDataSource>(
      () => AccountFbDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<TransactionFbDataSource>(
      () => TransactionFbDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<AnalysisFbDataSource>(
      () => AnalysisFbDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<NotificationDataSource>(
      () => NotificationDataSourceImpl(sl(), sl()));

  // **************************************** Repos ****************************************
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));
  sl.registerLazySingleton<BudgetRepo>(() => BudgetRepoImpl(sl()));
  sl.registerLazySingleton<AccountRepo>(() => AccountRepoImpl(sl()));
  sl.registerLazySingleton<TransactionRepo>(() => TransactionRepoImpl(sl()));
  sl.registerLazySingleton<AnalysisRepo>(() => AnalysisRepoImpl(sl()));
  sl.registerLazySingleton<NotificationRepo>(() => NotificationRepoImpl(sl()));

  // **************************************** Bloc ****************************************
  sl.registerSingleton<AuthBloc>(AuthBloc(sl(), sl()));
  sl.registerSingleton<BudgetViewBloc>(BudgetViewBloc(sl()));
  sl.registerSingleton<BudgetEditBloc>(BudgetEditBloc(sl()));
  sl.registerSingleton<CategoryViewBloc>(CategoryViewBloc(sl()));
  sl.registerSingleton<CategoryEditBloc>(CategoryEditBloc(sl()));
  sl.registerSingleton<MonthTransViewBloc>(MonthTransViewBloc(sl()));
  sl.registerSingleton<TransactionEditBloc>(TransactionEditBloc(sl(), sl()));
  sl.registerSingleton<AnalysisBloc>(AnalysisBloc(sl()));
  sl.registerSingleton<TransactionBloc>(TransactionBloc(sl()));
  sl.registerSingleton<AccountBloc>(AccountBloc(sl()));
}
