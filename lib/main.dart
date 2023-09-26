import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loonaz_application/View%20Model/ringtone_view_model.dart';
import 'package:loonaz_application/View%20Model/search_view_model.dart';
import 'package:loonaz_application/View%20Model/wallapaper_view_model.dart';
import 'package:loonaz_application/src/features/screens/splash_screen/splash_screen.dart';
import 'package:loonaz_application/src/utils/theme/theme.dart';
import 'package:provider/provider.dart';

import 'View Model/auth_view_model.dart';
import 'View Model/dp_wallpaper_view_model.dart';
import 'View Model/live_wallpaper_view_model.dart';
import 'View Model/pfps_wallpaper_view_model.dart';
import 'View Model/single_category_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => WallPaperViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => RingToneViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SingleCategoryViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => DpsWallPaperViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LiveWallPaperViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PfPsWallPaperViewModel(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => AuthViewModel(),
        // )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ringtones',
        theme: TAppTheme.lightTheme,
        // darkTheme: TAppTheme.darkTheme,
        // themeMode: ThemeMode.system,
        home: SplashScreen(),
      ),
    );
  }
}
