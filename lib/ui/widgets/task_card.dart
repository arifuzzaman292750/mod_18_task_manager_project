import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_revision/data/models/task_model.dart';
import 'package:task_manager_app_revision/ui/controllers/change_status_task_card_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/delete_task_card_controller.dart';
import 'package:task_manager_app_revision/ui/utils/app_colors.dart';
import 'package:task_manager_app_revision/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_revision/ui/widgets/snack_bar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.onRefreshList,
  });

  final TaskModel taskModel;
  final VoidCallback onRefreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String _selectedStatus = '';
  final DeleteTaskCardController _deleteTaskCardController =
      Get.find<DeleteTaskCardController>();
  final ChangeStatusTaskCardController _changeStatusTaskCardController =
      Get.find<ChangeStatusTaskCardController>();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title ?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              widget.taskModel.description ?? '',
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${widget.taskModel.createdDate ?? ''}',
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTaskStatusChip(),
                Wrap(
                  children: [
                    GetBuilder<ChangeStatusTaskCardController>(
                        builder: (controller) {
                      return Visibility(
                        visible: !controller.inProgress,
                        replacement: const CenteredCircularProgressIndicator(),
                        child: IconButton(
                          onPressed: _onTapEditButton,
                          icon: const Icon(Icons.edit),
                        ),
                      );
                    }),
                    GetBuilder<DeleteTaskCardController>(builder: (controller) {
                      return Visibility(
                        visible: !controller.inProgress,
                        replacement: const CenteredCircularProgressIndicator(),
                        child: IconButton(
                          onPressed: _onTapDeleteButton,
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatusChip() {
    return Chip(
      label: Text(
        widget.taskModel.status!,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: const BorderSide(
        color: AppColors.themeColor,
      ),
    );
  }

  void _onTapEditButton() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['New', 'Completed', 'Cancelled', 'Progress'].map(
              (e) {
                return ListTile(
                  onTap: () {
                    _changeStatus(e);
                    //Navigator.pop(context);
                    Get.back();
                  },
                  title: Text(e),
                  selected: _selectedStatus == e,
                  trailing:
                      _selectedStatus == e ? const Icon(Icons.check) : null,
                );
              },
            ).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                //Navigator.pop(context);
                Get.back();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changeStatus(String newStatus) async {
    final bool result =
        await _changeStatusTaskCardController.getChangeStatusTaskCard(
      widget.taskModel.sId!,
      newStatus,
    );
    if (result) {
      widget.onRefreshList();
    } else {
      showSnackBarMessage(context, _changeStatusTaskCardController.errorMessage!, true);
    }
  }

  Future<void> _onTapDeleteButton() async {
    final bool result = await _deleteTaskCardController
        .getDeleteTaskCard(widget.taskModel.sId!);
    if (result) {
      widget.onRefreshList();
    } else {
      showSnackBarMessage(
          context, _deleteTaskCardController.errorMessage!, true);
    }
  }
}
