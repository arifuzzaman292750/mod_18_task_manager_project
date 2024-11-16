import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_revision/ui/controllers/auth_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/pick_image_controller.dart';
import 'package:task_manager_app_revision/ui/controllers/profile_controller.dart';
import 'package:task_manager_app_revision/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_revision/ui/widgets/screen_background.dart';
import 'package:task_manager_app_revision/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app_revision/ui/widgets/tm_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String name = '/profileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProfileController _profileController = Get.find<ProfileController>();
  final PickImageController _pickImageController = Get.find<PickImageController>();

  //XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _setUserData();
  }

  void _setUserData() {
    _emailTEController.text = AuthController.userData?.email ?? '';
    _firstNameTEController.text = AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _mobileTEController.text = AuthController.userData?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(
        isProfileScreenOpen: true,
      ),
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
                    'Update Profile',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 24),
                  _buildPhotoPicker(),
                  const SizedBox(height: 8),
                  TextFormField(
                    enabled: false,
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'Mobile'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(height: 24),
                  GetBuilder<ProfileController>(builder: (controller) {
                    return Visibility(
                      visible: !controller.inProgress,
                      replacement: const CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapNextButton,
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
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GetBuilder<PickImageController>(
              builder: (controller) {
                return Text(controller.selectedImage?.name ?? 'select photo');
              }
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _pickImage() async {
    final bool result = await _pickImageController.getPickImage();

    if(result) {
      showSnackBarMessage(context, 'Image successfully picked');
    } else {
      showSnackBarMessage(context, 'Something went wrong', true);
    }
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    final bool result = await _profileController.getProfile(
      _emailTEController.text.trim(),
      _firstNameTEController.text.trim(),
      _lastNameTEController.text.trim(),
      _mobileTEController.text.trim(),
      _passwordTEController.text.trim(),
      _pickImageController.selectedImage,
    );

    if (result) {
      showSnackBarMessage(context, 'Profile has been updated');
      //Get.offAllNamed(MainBottomNavBarScreen.name);
    } else {
      showSnackBarMessage(context, _profileController.errorMessage!, true);
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
