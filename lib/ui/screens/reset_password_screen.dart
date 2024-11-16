import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_revision/ui/controllers/reset_password_controller.dart';
import 'package:task_manager_app_revision/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app_revision/ui/utils/app_colors.dart';
import 'package:task_manager_app_revision/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_revision/ui/widgets/screen_background.dart';
import 'package:task_manager_app_revision/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});

  static const String name = '/resetPasswordScreen';

  final String email;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final ResetPasswordController _resetPasswordController =
      Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 84),
                Text(
                  'Set Password',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Minimum length of password 8 characters with Letters and Numbers combination',
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                _buildResetPasswordForm(),
                const SizedBox(height: 24),
                Center(
                  child: _buildHaveAccountSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _passwordTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'Password'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter password';
              }
              if (value!.length <= 6) {
                return 'Enter a password more than 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'Confirm Password'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter confirm password';
              }
              if (value != _passwordTEController.text) {
                return "Password doesn't match";
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          GetBuilder<ResetPasswordController>(builder: (controller) {
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
    );
  }

  void _onTapNextButton() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _resetPassword();
  }

  Future<void> _resetPassword() async {
    final bool result = await _resetPasswordController.getResetPassword(
      widget.email,
      widget.otp,
      _passwordTEController.text,
    );

    if (result) {
      showSnackBarMessage(context, 'Password reset successfully');
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, SignInScreen.name);
      //Navigator.pushReplacement(
        //context,
        //MaterialPageRoute(
          //builder: (context) => const SignInScreen(),
       // ),
      //);
      //Get.offAllNamed(SignInScreen.name);
      //Get.offNamedUntil(SignInScreen.name, (predicate) => false);
    } else {
      showSnackBarMessage(
          context, _resetPasswordController.errorMessage!, true);
    }
  }

  Widget _buildHaveAccountSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        text: "Have account? ",
        children: [
          TextSpan(
            text: 'Sign in',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
            recognizer: TapGestureRecognizer()..onTap = _onTapSignIn,
          ),
        ],
      ),
    );
  }

  void _onTapSignIn() {
    Navigator.pushReplacementNamed(context, SignInScreen.name);
    //Navigator.pushReplacement(
      //context,
      //MaterialPageRoute(
        //builder: (context) => const SignInScreen(),
      //),
    //);
    //Navigator.pushAndRemoveUntil(
    //context,
    //MaterialPageRoute(
   // builder: (context) => const SignInScreen(),
   // ),
    //(predicate) => false,
    //);
    //Get.offNamedUntil(SignInScreen.name, (predicate) => false);
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
