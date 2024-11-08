import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_app_revision/data/models/network_response.dart';
import 'package:task_manager_app_revision/data/services/network_caller.dart';
import 'package:task_manager_app_revision/data/utils/urls.dart';
import 'package:task_manager_app_revision/ui/screens/reset_password_screen.dart';
import 'package:task_manager_app_revision/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app_revision/ui/utils/app_colors.dart';
import 'package:task_manager_app_revision/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_revision/ui/widgets/screen_background.dart';
import 'package:task_manager_app_revision/ui/widgets/snack_bar_message.dart';

class ForgetPasswordOtpScreen extends StatefulWidget {
  const ForgetPasswordOtpScreen({super.key, required this.email});

  final String email;

  @override
  State<ForgetPasswordOtpScreen> createState() =>
      _ForgetPasswordOtpScreenState();
}

class _ForgetPasswordOtpScreenState extends State<ForgetPasswordOtpScreen> {
  final TextEditingController _otpFillTEController = TextEditingController();

  bool _otpInProgress = false;
  bool _isOtpVerified = false;

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
                  'PIN Verification',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A 6 digits verification otp has been sent to your email address',
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                _buildOtpForm(),
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

  Widget _buildOtpForm() {
    return Column(
      children: [
        PinCodeTextField(
          controller: _otpFillTEController,
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            selectedFillColor: Colors.white,
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          appContext: context,
          onChanged: (value) {
            if (value.length == 6) {
              _isOtpVerified = true;
              setState(() {});
            } else {
              _isOtpVerified = false;
              setState(() {});
            }
          },
        ),
        const SizedBox(height: 24),
        Visibility(
          visible: _otpInProgress == false,
          replacement: const CenteredCircularProgressIndicator(),
          child: ElevatedButton(
            onPressed: _isOtpVerified ? _onTapNextButton : null,
            child: const Icon(Icons.arrow_circle_right_outlined),
          ),
        ),
      ],
    );
  }

  void _onTapNextButton() {
    if (_otpFillTEController.text.length != 6) {
      showSnackBarMessage(context, 'Please enter the 6-digit otp');
      setState(() {});
      return;
    }
    _forgetPasswordOtp();
  }

  Future<void> _forgetPasswordOtp() async {
    _otpInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      url:
          '${Urls.forgetPasswordOtp}/${widget.email}/${_otpFillTEController.text.trim()}',
    );

    _otpInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      showSnackBarMessage(context, 'Verification Successful');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            email: widget.email,
            otp: _otpFillTEController.text.trim(),
          ),
        ),
      );
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
      (predicate) => false,
    );
  }

  @override
  void dispose() {
    _otpFillTEController.dispose();
    super.dispose();
  }
}
