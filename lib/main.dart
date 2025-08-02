import 'package:dynamicform/providers/form_provider.dart';
import 'package:dynamicform/screens/form_list_page.dart';
import 'package:dynamicform/screens/form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
            elevation: 0, // Removes shadow if any
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF03a9ff),),
          useMaterial3: true,
        ),
        initialRoute: '/form-list',
        routes: {
          FormListPage.routeName : (_) => const FormListPage(),
          FormPage.routeName : (_) => const FormPage(),
        },
      ),
    );
  }
}

