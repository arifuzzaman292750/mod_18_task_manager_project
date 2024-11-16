import 'package:get/get.dart';
import 'package:task_manager_app_revision/data/models/network_response.dart';
import 'package:task_manager_app_revision/data/services/network_caller.dart';
import 'package:task_manager_app_revision/data/utils/urls.dart';

class AddNewTaskController extends GetxController {
  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> getAddNewTask(
      String title, String description, String status) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status": status,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.addNewTask,
      body: requestBody,
    );

    _inProgress = false;
    update();

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    return isSuccess;
  }
}
