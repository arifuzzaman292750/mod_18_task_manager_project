import 'package:get/get.dart';
import 'package:task_manager_app_revision/data/models/network_response.dart';
import 'package:task_manager_app_revision/data/services/network_caller.dart';
import 'package:task_manager_app_revision/data/utils/urls.dart';

class DeleteTaskCardController extends GetxController {
  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> getDeleteTaskCard(String sId) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.deleteTask(sId));
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
