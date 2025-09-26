import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meetly/firebase_options.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/service_locator.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize dependency injection
  ServiceLocator.instance.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ServiceLocator.instance.authProvider,
      child: MaterialApp(
        title: 'Meetly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.bricolageGrotesqueTextTheme(
            AppTheme.lightTheme.textTheme,
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
