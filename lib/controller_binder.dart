import 'package:get/get.dart';
import 'package:task_manager_app_revision/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/auth_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/cancelled_task_list_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/change_status_task_card_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/completed_task_list_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/delete_task_card_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/forget_password_email_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/forget_password_otp_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/main_bottom_nav_bar_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/new_task_list_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/pick_image_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/profile_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/progress_task_list_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/reset_password_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/sign_in_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/sign_up_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/task_status_count_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(SignInController());
    Get.put(NewTaskListController());
    Get.put(TaskStatusCountController());
    Get.put(CompletedTaskListController());
    Get.put(CancelledTaskListController());
    Get.put(ProgressTaskListController());
    Get.put(SignUpController());
    Get.put(AddNewTaskController());
    Get.put(DeleteTaskCardController());
    Get.put(ChangeStatusTaskCardController());
    Get.put(ForgetPasswordEmailController());
    Get.put(ForgetPasswordOtpController());
    Get.put(ResetPasswordController());
    Get.put(ProfileController());
    Get.put(MainBottomNavBarController());
    Get.put(PickImageController());
  }
}