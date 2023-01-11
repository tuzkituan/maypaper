import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:maypaper/models/theme_model.dart';
import 'package:maypaper/providers/home_page_provider.dart';
import 'package:maypaper/home_layout.dart';
import 'package:maypaper/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({
    Key? key,
    required this.sharedPreferences,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late HomePageProvider homePageService;
  late ThemeModel themeModel;
  late StreamSubscription<bool> authSubscription;

  @override
  void initState() {
    themeModel = ThemeModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeModel),
        ChangeNotifierProvider(create: (ctx) => HomePageProvider())
      ],
      child: Builder(
        builder: (context) {
          final isDark = Provider.of<ThemeModel>(context).isDark;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MAYPAPER',
            scaffoldMessengerKey: snackbarKey,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const HomeLayout(),
            scrollBehavior: MyCustomScrollBehavior(),
          );
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
