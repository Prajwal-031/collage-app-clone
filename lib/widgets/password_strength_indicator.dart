import 'package:flutter/material.dart';

enum PasswordStrength {
  empty,
  weak,
  medium,
  strong,
}

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    Key? key,
    required this.password,
  }) : super(key: key);

  PasswordStrength _calculatePasswordStrength() {
    if (password.isEmpty) {
      return PasswordStrength.empty;
    }
    
    // Basic strength parameters
    bool hasMinLength = password.length >= 8;
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    int strength = 0;
    if (hasMinLength) strength++;
    if (hasUppercase) strength++;
    if (hasLowercase) strength++;
    if (hasDigit) strength++;
    if (hasSpecialChar) strength++;
    
    if (strength <= 2) return PasswordStrength.weak;
    if (strength <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  @override
  Widget build(BuildContext context) {
    final strength = _calculatePasswordStrength();
    
    if (strength == PasswordStrength.empty) {
      return const SizedBox.shrink();
    }
    
    String strengthText = '';
    Color strengthColor = Colors.grey;
    int indicatorValue = 0;
    
    switch (strength) {
      case PasswordStrength.weak:
        strengthText = 'Weak';
        strengthColor = Colors.red;
        indicatorValue = 1;
        break;
      case PasswordStrength.medium:
        strengthText = 'Medium';
        strengthColor = Colors.orange;
        indicatorValue = 2;
        break;
      case PasswordStrength.strong:
        strengthText = 'Strong';
        strengthColor = Colors.green;
        indicatorValue = 3;
        break;
      case PasswordStrength.empty:
        // Already handled
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final segmentWidth = totalWidth / 3;
                  final segments = <Widget>[];
                  
                  for (int i = 0; i < 3; i++) {
                    segments.add(
                      Container(
                        width: segmentWidth - 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i < indicatorValue ? strengthColor : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }
                  
                  return Row(children: segments);
                },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              strengthText,
              style: TextStyle(
                fontSize: 12,
                color: strengthColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Password should be at least 8 characters with uppercase, lowercase, numbers and special characters',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
} 