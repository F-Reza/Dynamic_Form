import 'providers/form_provider.dart';
import 'screens/form_list_page.dart';
import 'screens/form_page1.dart';
import 'screens/form_page2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/form_page3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FormProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dynamic Form App',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF03a9ff),
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF03a9ff),),
          useMaterial3: true,
        ),
        initialRoute: '/form-list',
        routes: {
          FormListPage.routeName : (_) => const FormListPage(),
          FormPage1.routeName : (_) => const FormPage1(),
          FormPage2.routeName : (_) => const FormPage2(),
          FormPage3.routeName : (_) => const FormPage3(),
        },
      ),
    );
  }
}

