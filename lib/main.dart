import 'package:flutter/material.dart';
import 'package:master_plan/models/plan.dart';
import 'package:master_plan/views/plan_creator_screen.dart';
import './views/plan_screen.dart';
import './provider/plan_provider.dart';

void main() => runApp(MasterPlanApp());

class MasterPlanApp extends StatelessWidget {
  const MasterPlanApp({super.key});

  @override
   Widget build(BuildContext context) {
    return PlanProvider(
      notifier: ValueNotifier<List<Plan>>([]),
      child: MaterialApp(
        title: 'Master Plan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        home: const PlanCreatorScreen(),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return PlanProvider(
  //     notifier: ValueNotifier<List<Plan>>([]),
  //     child: MaterialApp(
  //       title: 'State management app',
  //       theme: ThemeData(
  //         primarySwatch: Colors.blue,
  //       ),
  //       home: const PlanCreatorScreen(), // Change to PlanCreatorScreen
  //     ),
  //   );
  // }
}
