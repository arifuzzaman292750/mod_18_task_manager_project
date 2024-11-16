import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_revision/ui/controllers/auth_controller.dart';
import 'package:task_manager_app_revision/ui/screens/profile_screen.dart';
import 'package:task_manager_app_revision/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app_revision/ui/utils/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.isProfileScreenOpen = false,
  });

  final bool isProfileScreenOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(isProfileScreenOpen == true) {
          return;
        }
        //Navigator.push(
          //context,
          //MaterialPageRoute(
            //builder: (context) => const ProfileScreen(),
          //),
        //);
        Get.toNamed(ProfileScreen.name);
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userData?.fullName ?? '',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    AuthController.userData?.email ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await AuthController.clearUserData();
                //Navigator.pushAndRemoveUntil(
                  //context,
                  //MaterialPageRoute(
                    //builder: (context) => const SignInScreen(),
                  //),
                  //(predicate) => false,
                //);
                Get.offAllNamed(SignInScreen.name);
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
