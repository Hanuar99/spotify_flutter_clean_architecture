import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/core/router/app_router.dart';
import 'package:spotify/firebase_options.dart';
import 'package:spotify/main_app.dart';
import 'package:spotify/presentation/choose_mode/cubit/theme_cubit.dart';
import 'package:spotify/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getTemporaryDirectory()).path,
          ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDependencies(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: MainApp(router: sl<AppRouter>().router),
    ),
  );
}
