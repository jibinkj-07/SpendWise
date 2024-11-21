import '../../../features/home/presentation/helper/home_helper.dart';
import './imports.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // **************************************** Class ****************************************
  sl.registerLazySingleton<AccountHelper>(() => AccountHelper(sl()));
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
  sl.registerLazySingleton<ExpenseFbDataSource>(
    () => ExpenseFbDataSourceImpl(sl(), sl()),
  );

  // **************************************** Repos ****************************************
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));
  sl.registerLazySingleton<ExpenseRepo>(() => ExpenseRepoImpl(sl()));

  // **************************************** Bloc ****************************************
  sl.registerSingleton<AuthBloc>(AuthBloc(sl()));
  sl.registerSingleton<ExpenseBloc>(ExpenseBloc(
    sl(),
    sl(),
    sl(),
    sl(),
  ));
}
