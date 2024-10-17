
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

  // **************************************** Repos ****************************************
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));

  // **************************************** Bloc ****************************************
  sl.registerSingleton<AuthBloc>(AuthBloc(sl(), sl()));
}
