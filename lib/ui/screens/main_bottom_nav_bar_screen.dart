import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_revision/ui/controllers/main_bottom_nav_bar_controller.dart';
import 'package:task_manager_app_revision/ui/screens/cancelled_task_screen.dart';
import 'package:task_manager_app_revision/ui/screens/completed_task_screen.dart';
import 'package:task_manager_app_revision/ui/screens/new_task_screen.dart';
import 'package:task_manager_app_revision/ui/screens/progress_task_screen.dart';
import 'package:task_manager_app_revision/ui/widgets/tm_app_bar.dart';

class MainBottomNavBarScreen extends StatefulWidget {
  const MainBottomNavBarScreen({super.key});

  static const String name = '/home';

  @override
  State<MainBottomNavBarScreen> createState() => _MainBottomNavBarScreenState();
}

class _MainBottomNavBarScreenState extends State<MainBottomNavBarScreen> {

  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    ProgressTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: GetBuilder<MainBottomNavBarController>(
        builder: (controller) {
          return _screens[controller.selectedIndex];
        }
      ),
      bottomNavigationBar: GetBuilder<MainBottomNavBarController>(
        builder: (controller) {
          return NavigationBar(
            selectedIndex: controller.selectedIndex,
            onDestinationSelected: (int index) {
              controller.updateIndex(index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.new_label),
                label: 'New',
              ),
              NavigationDestination(
                icon: Icon(Icons.check_box),
                label: 'Completed',
              ),
              NavigationDestination(
                icon: Icon(Icons.close),
                label: 'Cancelled',
              ),
              NavigationDestination(
                icon: Icon(Icons.access_time_outlined),
                label: 'Progress',
              ),
            ],
          );
        }
      ),
    );
  }
}
