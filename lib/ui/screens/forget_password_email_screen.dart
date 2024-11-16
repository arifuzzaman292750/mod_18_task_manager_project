import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_revision/ui/controllers/forget_password_email_controller.dart';
import 'package:task_manager_app_revision/ui/screens/forget_password_otp_screen.dart';
import 'package:task_manager_app_revision/ui/utils/app_colors.dart';
import 'package:task_manager_app_revision/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_revision/ui/widgets/screen_background.dart';
import 'package:task_manager_app_revision/ui/widgets/snack_bar_message.dart';

class ForgetPasswordEmailScreen extends StatefulWidget {
  const ForgetPasswordEmailScreen({super.key});

  static const String name = '/forgetPasswordEmailScreen';

  @override
  State<ForgetPasswordEmailScreen> createState() =>
      _ForgetPasswordEmailScreenState();
}

class _ForgetPasswordEmailScreenState extends State<ForgetPasswordEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ForgetPasswordEmailController _forgetPasswordEmailController =
      Get.find<ForgetPasswordEmailController>();

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
                  'Your Email Address',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A 6 digits verification otp will be sent to your email address',
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                _buildVerifyEmailForm(),
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

  Widget _buildVerifyEmailForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter your email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          GetBuilder<ForgetPasswordEmailController>(builder: (controller) {
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
    _forgetPasswordEmail(_emailTEController.text);
  }

  Future<void> _forgetPasswordEmail(String email) async {
    final bool result =
        await _forgetPasswordEmailController.getForgetPasswordEmail(email);
    if (result) {
      showSnackBarMessage(context, 'OTP has been send to your email');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgetPasswordOtpScreen(email: email),
        ),
      );
      //Get.toNamed(ForgetPasswordOtpScreen.name,
      //arguments: _emailTEController.text);
    } else {
      showSnackBarMessage(
          context, _forgetPasswordEmailController.errorMessage!, true);
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
    //Navigator.pop(context);
    Get.back();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
