import 'package:app/pages/auth/register.dart';
import 'package:app/pages/common/common_page.dart';
import 'package:app/themes/custom_colors.dart';
import 'package:app/pages/welcome/start_page.dart';
import 'package:app/provider/user/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MainApp());
}

ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.light,
    ),
    extensions: [
      CustomColors(
          primaryColor: Colors.indigo[200],
          secondaryColor: Colors.indigo,
          iconColor: Colors.grey[800])
    ]);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
  ),
  // Other theme properties
);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider())
        ],
        child: MaterialApp(
            navigatorKey: navigatorKey,
            theme: lightTheme,
            debugShowCheckedModeBanner: false,
            home: StartPage()));
  }
}
