import 'package:flutter/material.dart';
import 'package:frontend/dashboard%20screen/dashboard_screen.dart';
import 'package:frontend/login%20screens/login_screen.dart';
import 'package:frontend/login%20screens/register_screen.dart';
import 'package:frontend/welcome%20screens/welcome_screen.dart';
import 'package:frontend/utils/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = HttpOverridesImpl();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: MyAppWrapper(),
    ),
  );
}

// Bypasses security for local backend access during development
class HttpOverridesImpl extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyAppWrapper extends StatefulWidget {
  @override
  _MyAppWrapperState createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  bool? isLoggedIn;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      isLoggedIn = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()), // Loading screen
        ),
      );
    }

    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeManager.themeMode,
          initialRoute: isLoggedIn! ? '/welcome' : '/login',
          routes: {
            '/login': (context) => LoginScreen(),
            '/welcome': (context) => WelcomeScreen(),
            '/register': (context) => RegisterScreen(),
            '/dashboard': (context) =>
                DashboardScreen(onThemeChanged: themeManager.toggleTheme),
          },
        );
      },
    );
  }
}
