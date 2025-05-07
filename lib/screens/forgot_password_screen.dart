import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import '../services/theme_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/message_banner.dart';
import '../widgets/university_logo.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService _auth = AuthService();
  final NavigationService _navigationService = NavigationService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final TextEditingController _emailController = TextEditingController();
  
  bool _isLoading = false;
  String? _message;
  MessageType _messageType = MessageType.info;
  
  @override
  void initState() {
    super.initState();
    // Log when screen is initialized
    developer.log('Forgot Password Screen initialized', name: 'ForgotPasswordScreen');
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    final email = _emailController.text.trim();
    developer.log('Attempting password reset for email: $email', name: 'ForgotPasswordScreen');
    
    setState(() {
      _isLoading = true;
      _message = null;
    });
    
    try {
      final result = await _auth.resetPassword(email);
      
      developer.log('Password reset result: $result', name: 'ForgotPasswordScreen');
      
      setState(() {
        _isLoading = false;
        _message = result['message'];
        _messageType = result['success'] ? MessageType.success : MessageType.error;
      });
      
      // If successful, clear the form
      if (result['success']) {
        _emailController.clear();
        
        // Show a snackbar for additional feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent successfully'),
            backgroundColor: ThemeService.successColor,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      developer.log('Error during password reset: $e', name: 'ForgotPasswordScreen', error: e);
      setState(() {
        _isLoading = false;
        _message = 'An unexpected error occurred: $e';
        _messageType = MessageType.error;
      });
    }
  }
  
  void _navigateToLogin() {
    _navigationService.navigateToReplacement(AppConstants.ROUTE_LOGIN);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeService.textColor),
          onPressed: _navigateToLogin,
        ),
        title: Text(
          'Forgot Password',
          style: TextStyle(
            color: ThemeService.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // University Logo
                Center(
                  child: UniversityLogo(
                    size: 60,
                    showTagline: false,
                  ),
                ),
                SizedBox(height: 40),
                
                // Instructions
                Text(
                  'Reset Your Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ThemeService.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Enter your email address and we\'ll send you instructions to reset your password.',
                  style: TextStyle(
                    fontSize: 16,
                    color: ThemeService.secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                
                // Status Message
                if (_message != null) 
                  MessageBanner(
                    message: _message!,
                    type: _messageType,
                    onDismiss: () {
                      setState(() {
                        _message = null;
                      });
                    },
                  ),
                
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(Icons.email_outlined),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _resetPassword(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(AppConstants.EMAIL_REGEX).hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      
                      // Submit Button
                      CustomButton(
                        text: 'Reset Password',
                        onPressed: _resetPassword,
                        isLoading: _isLoading,
                      ),
                      SizedBox(height: 16),
                      
                      // Back to Login
                      Center(
                        child: TextButton.icon(
                          onPressed: _navigateToLogin,
                          icon: Icon(Icons.arrow_back, size: 16),
                          label: Text(
                            'Back to Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 