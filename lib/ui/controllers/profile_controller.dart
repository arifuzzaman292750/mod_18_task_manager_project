import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app_revision/data/models/network_response.dart';
import 'package:task_manager_app_revision/data/models/user_model.dart';
import 'package:task_manager_app_revision/data/services/network_caller.dart';
import 'package:task_manager_app_revision/data/utils/urls.dart';
import 'package:task_manager_app_revision/ui/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  AuthController authController = Get.find<AuthController>();

  Future<bool> getProfile(String email, String firstName, String lastName,
      String mobile, String password, XFile? selectedImage) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    String? convertedImage;

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password.isNotEmpty) {
      requestBody['password'] = password;
    }

    if (selectedImage != null) {
      List<int> imageBytes = await selectedImage.readAsBytes();
      convertedImage = base64Encode(imageBytes);
      requestBody['photo'] = convertedImage;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.profileUpdate,
      body: requestBody,
    );

    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();

    return isSuccess;
  }
}
