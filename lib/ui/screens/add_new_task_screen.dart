import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_revision/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager_app_revision/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_revision/ui/widgets/screen_background.dart';
import 'package:task_manager_app_revision/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app_revision/ui/widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  static const String name = '/addNewTaskScreen';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  bool _shouldRefreshPreviousScreen = false;
  final AddNewTaskController _addNewTaskController =
      Get.find<AddNewTaskController>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _shouldRefreshPreviousScreen);
      },
      child: Scaffold(
        appBar: const TMAppBar(),
        body: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 84),
                    Text(
                      'Add New Task',
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _titleTEController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(hintText: 'Title'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter a value';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionTEController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 5,
                      decoration:
                          const InputDecoration(hintText: 'Description'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter a value';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    GetBuilder<AddNewTaskController>(builder: (controller) {
                      return Visibility(
                        visible: !controller.inProgress,
                        replacement: const CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: _onTapSubmitButton,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    final bool result = await _addNewTaskController.getAddNewTask(
      _titleTEController.text.trim(),
      _descriptionTEController.text.trim(),
      "New",
    );

    if (result) {
      _shouldRefreshPreviousScreen = true;
      _clearTextFields();
      showSnackBarMessage(context, 'New task added!');
      //Navigator.pushReplacement(
        //context,
        //MaterialPageRoute(
          //builder: (context) => const MainBottomNavBarScreen(),
        //),
      //);
      //Get.offNamed(MainBottomNavBarScreen.name);
    } else {
      showSnackBarMessage(context, _addNewTaskController.errorMessage!, true);
    }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
