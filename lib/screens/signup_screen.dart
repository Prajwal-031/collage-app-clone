import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import '../services/theme_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/message_banner.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/university_logo.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final NavigationService _navigationService = NavigationService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _acceptTerms = false;
  String? _errorMessage;
  String _password = '';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
    
    _passwordController.addListener(_updatePassword);
  }
  
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  void _updatePassword() {
    setState(() {
      _password = _passwordController.text;
    });
  }
  
  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }
  
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _confirmPasswordVisible = !_confirmPasswordVisible;
    });
  }
  
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_acceptTerms) {
      setState(() {
        _errorMessage = 'Please accept the Terms and Conditions to continue';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    final result = await _auth.registerWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _fullNameController.text.trim(),
    );
    
    if (result['success']) {
      // Navigate to home screen
      _navigationService.navigateToAndRemoveUntil(AppConstants.ROUTE_HOME);
    } else {
      setState(() {
        _errorMessage = result['message'];
        _isLoading = false;
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // University Logo
                  Center(
                    child: Column(
                      children: [
                        UniversityLogo(
                          size: 60,
                          showTagline: true,
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                  
                  // Welcome Text
                  Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ThemeService.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Join Amity University Bengaluru',
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeService.secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  
                  // Error Message
                  if (_errorMessage != null) 
                    MessageBanner(
                      message: _errorMessage!,
                      type: MessageType.error,
                      onDismiss: () {
                        setState(() {
                          _errorMessage = null;
                        });
                      },
                    ),
                  
                  // Signup Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          controller: _fullNameController,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          prefixIcon: Icon(Icons.person_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(Icons.email_outlined),
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
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Create a password',
                          isPassword: true,
                          isPasswordVisible: _passwordVisible,
                          onTogglePasswordVisibility: _togglePasswordVisibility,
                          prefixIcon: Icon(Icons.lock_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < AppConstants.MIN_PASSWORD_LENGTH) {
                              return 'Password must be at least ${AppConstants.MIN_PASSWORD_LENGTH} characters';
                            }
                            return null;
                          },
                        ),
                        
                        // Password Strength Indicator
                        PasswordStrengthIndicator(password: _password),
                        SizedBox(height: 20),
                        
                        CustomTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hint: 'Confirm your password',
                          isPassword: true,
                          isPasswordVisible: _confirmPasswordVisible,
                          onTogglePasswordVisibility: _toggleConfirmPasswordVisibility,
                          prefixIcon: Icon(Icons.lock_outline),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        
                        // Terms and Conditions
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              activeColor: ThemeService.primaryColor,
                            ),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ThemeService.textColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: TextStyle(
                                        color: ThemeService.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      // Add onTap for terms & conditions if needed
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: ThemeService.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      // Add onTap for privacy policy if needed
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        
                        // Sign Up Button
                        CustomButton(
                          text: 'Sign Up',
                          onPressed: _signUp,
                          isLoading: _isLoading,
                        ),
                        SizedBox(height: 16),
                        
                        // Alternative Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: ThemeService.secondaryTextColor,
                              ),
                            ),
                            TextButton(
                              onPressed: _navigateToLogin,
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ThemeService.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 