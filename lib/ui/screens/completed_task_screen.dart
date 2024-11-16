import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_revision/ui/controllers/completed_task_list_controller.dart';
import 'package:task_manager_app_revision/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_revision/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app_revision/ui/widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  static const String name = '/completedTaskScreen';

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final CompletedTaskListController _completedTaskListController =
      Get.find<CompletedTaskListController>();

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompletedTaskListController>(
      builder: (controller) {
        return Visibility(
          visible: !controller.inProgress,
          replacement: const CenteredCircularProgressIndicator(),
          child: RefreshIndicator(
            onRefresh: () async {
              _getCompletedTaskList();
            },
            child: ListView.separated(
              itemCount: controller.completedTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskModel: controller.completedTaskList[index],
                  onRefreshList: _getCompletedTaskList,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
            ),
          ),
        );
      }
    );
  }

  Future<void> _getCompletedTaskList() async {
    final bool result = await _completedTaskListController.getCompletedTaskList();
    if (result == false) {
      showSnackBarMessage(context, _completedTaskListController.errorMessage!, true);
    }
  }
}
