import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_revision/controller_binder.dart';
import 'package:task_manager_app_revision/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_app_revision/ui/screens/cancelled_task_screen.dart';
import 'package:task_manager_app_revision/ui/screens/completed_task_screen.dart';
import 'package:task_manager_app_revision/ui/screens/forget_password_email_screen.dart';
import 'package:task_manager_app_revision/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:task_manager_app_revision/ui/screens/new_task_screen.dart';
import 'package:task_manager_app_revision/ui/screens/profile_screen.dart';
import 'package:task_manager_app_revision/ui/screens/progress_task_screen.dart';
import 'package:task_manager_app_revision/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app_revision/ui/screens/sign_up_screen.dart';
import 'package:task_manager_app_revision/ui/screens/splash_screen.dart';
import 'package:task_manager_app_revision/ui/utils/app_colors.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        inputDecorationTheme: _inputDecorationTheme(),
        elevatedButtonTheme: _elevatedButtonThemeData(),
      ),
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBinder(),
      initialRoute: '/',
      routes: {
        SplashScreen.name: (context) => const SplashScreen(),
        MainBottomNavBarScreen.name: (context) =>
            const MainBottomNavBarScreen(),
        SignInScreen.name: (context) => const SignInScreen(),
        NewTaskScreen.name: (context) => const NewTaskScreen(),
        CompletedTaskScreen.name: (context) => const CompletedTaskScreen(),
        CancelledTaskScreen.name: (context) => const CancelledTaskScreen(),
        ProgressTaskScreen.name: (context) => const ProgressTaskScreen(),
        SignUpScreen.name: (context) => const SignUpScreen(),
        ProfileScreen.name: (context) => const ProfileScreen(),
        AddNewTaskScreen.name: (context) => const AddNewTaskScreen(),
        ForgetPasswordEmailScreen.name: (context) => const ForgetPasswordEmailScreen(),
      },
    );
  }

  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: _outlineInputBorder(),
      errorBorder: _outlineInputBorder(),
      disabledBorder: _outlineInputBorder(),
      focusedBorder: _outlineInputBorder(),
      enabledBorder: _outlineInputBorder(),
      hintStyle: TextStyle(color: Colors.grey[400]),
    );
  }

  OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );
  }

  ElevatedButtonThemeData _elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        fixedSize: const Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
