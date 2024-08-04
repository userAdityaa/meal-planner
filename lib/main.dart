import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/core/common/loader.dart';
import 'package:flutter_meal_planner/core/utils/error_text.dart';
import 'package:flutter_meal_planner/features/auth/controllers/auth_controller.dart';
import 'package:flutter_meal_planner/firebase_options.dart';
import 'package:flutter_meal_planner/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (data != null) {
                  return loggedInRoute;
                } else {
                  return loggedOutRoute;
                }
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (e, stackTrace) => ErrorText(
            error: e.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
