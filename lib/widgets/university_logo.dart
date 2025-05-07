import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../utils/constants.dart';

class UniversityLogo extends StatelessWidget {
  final double size;
  final Color? textColor;
  final bool showTagline;

  const UniversityLogo({
    Key? key,
    this.size = 40,
    this.textColor,
    this.showTagline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use const widgets where possible to improve performance
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // University Logo - As we don't have an actual image,
            // we'll create a placeholder icon with the university's initials
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: ThemeService.universityPrimary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Precompute text widget with final value to avoid rebuilding
                Text(
                  AppConstants.UNIVERSITY_NAME,
                  style: TextStyle(
                    color: textColor ?? ThemeService.textColor,
                    fontSize: size * 0.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                if (showTagline)
                  Text(
                    AppConstants.UNIVERSITY_TAGLINE,
                    style: TextStyle(
                      color: textColor != null 
                          ? textColor!.withOpacity(0.8) 
                          : ThemeService.secondaryTextColor,
                      fontSize: size * 0.25,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// Memoized version for even better performance
class MemoizedUniversityLogo extends StatelessWidget {
  // Static cache of pre-built widgets
  static final Map<String, Widget> _cache = {};
  
  final double size;
  final Color? textColor;
  final bool showTagline;
  
  const MemoizedUniversityLogo({
    Key? key,
    this.size = 40,
    this.textColor,
    this.showTagline = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Create a unique key for this configuration
    final String cacheKey = '${size}_${textColor?.value}_$showTagline';
    
    // Return cached widget if available
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }
    
    // Otherwise build and cache the widget
    final Widget logo = UniversityLogo(
      size: size,
      textColor: textColor,
      showTagline: showTagline,
    );
    
    _cache[cacheKey] = logo;
    return logo;
  }
} 