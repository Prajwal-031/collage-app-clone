import 'package:flutter/material.dart';
import '../services/theme_service.dart';

enum MessageType { error, success, warning, info }

class MessageBanner extends StatelessWidget {
  final String message;
  final MessageType type;
  final VoidCallback? onDismiss;
  final bool showIcon;

  const MessageBanner({
    Key? key,
    required this.message,
    this.type = MessageType.info,
    this.onDismiss,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData iconData;

    switch (type) {
      case MessageType.error:
        backgroundColor = ThemeService.errorColor.withOpacity(0.1);
        textColor = ThemeService.errorColor;
        iconData = Icons.error_outline;
        break;
      case MessageType.success:
        backgroundColor = ThemeService.successColor.withOpacity(0.1);
        textColor = ThemeService.successColor;
        iconData = Icons.check_circle_outline;
        break;
      case MessageType.warning:
        backgroundColor = ThemeService.warningColor.withOpacity(0.1);
        textColor = ThemeService.warningColor;
        iconData = Icons.warning_amber_outlined;
        break;
      case MessageType.info:
      default:
        backgroundColor = ThemeService.primaryColor.withOpacity(0.1);
        textColor = ThemeService.primaryColor;
        iconData = Icons.info_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          if (showIcon) ...[
            Icon(iconData, color: textColor),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(Icons.close, color: textColor),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onDismiss,
            ),
        ],
      ),
    );
  }
} 