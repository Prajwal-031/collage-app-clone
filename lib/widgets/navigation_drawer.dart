import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'university_logo.dart';

class NavigationDrawer extends StatelessWidget {
  final String currentRoute;
  
  const NavigationDrawer({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final user = authService.currentUser;

    return Drawer(
      child: Column(
        children: [
          // Header with university info
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            color: ThemeService.universityPrimary,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UniversityLogo(
                  size: 56,
                  textColor: Colors.white,
                  showTagline: true,
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome, ${user?.displayName ?? 'Student'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                  context,
                  title: 'Home',
                  icon: Icons.home_outlined,
                  route: AppConstants.ROUTE_HOME,
                  isSelected: currentRoute == AppConstants.ROUTE_HOME,
                ),
                
                _buildSectionHeader('Academics'),
                _buildNavItem(
                  context,
                  title: 'Courses',
                  icon: Icons.book_outlined,
                  route: '/courses',
                ),
                _buildNavItem(
                  context,
                  title: 'Departments',
                  icon: Icons.business_outlined,
                  route: '/departments',
                ),
                _buildNavItem(
                  context,
                  title: 'Faculty',
                  icon: Icons.people_outline,
                  route: '/faculty',
                ),
                
                _buildSectionHeader('Student Services'),
                _buildNavItem(
                  context,
                  title: 'Examination',
                  icon: Icons.edit_note_outlined,
                  route: '/examination',
                ),
                _buildNavItem(
                  context,
                  title: 'Library',
                  icon: Icons.local_library_outlined,
                  route: '/library',
                ),
                _buildNavItem(
                  context,
                  title: 'Hostel',
                  icon: Icons.apartment_outlined,
                  route: '/hostel',
                ),
                
                _buildSectionHeader('Campus Life'),
                _buildNavItem(
                  context,
                  title: 'Events',
                  icon: Icons.event_outlined,
                  route: '/events',
                ),
                _buildNavItem(
                  context,
                  title: 'Clubs',
                  icon: Icons.groups_outlined,
                  route: '/clubs',
                ),
                _buildNavItem(
                  context,
                  title: 'Sports',
                  icon: Icons.sports_soccer_outlined,
                  route: '/sports',
                ),
                
                _buildSectionHeader('About'),
                _buildNavItem(
                  context,
                  title: 'About Us',
                  icon: Icons.info_outline,
                  route: '/about',
                ),
                _buildNavItem(
                  context,
                  title: 'Contact',
                  icon: Icons.contact_support_outlined,
                  route: '/contact',
                ),
                
                const Divider(),
                _buildNavItem(
                  context,
                  title: 'Profile',
                  icon: Icons.person_outline,
                  route: AppConstants.ROUTE_PROFILE,
                  isSelected: currentRoute == AppConstants.ROUTE_PROFILE,
                ),
                _buildNavItem(
                  context,
                  title: 'Settings',
                  icon: Icons.settings_outlined,
                  route: AppConstants.ROUTE_SETTINGS,
                  isSelected: currentRoute == AppConstants.ROUTE_SETTINGS,
                ),
                _buildNavItem(
                  context,
                  title: 'Logout',
                  icon: Icons.logout_outlined,
                  onTap: () async {
                    await authService.signOut();
                    Navigator.pushReplacementNamed(context, AppConstants.ROUTE_LOGIN);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: ThemeService.secondaryTextColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    String? route,
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: Icon(
        icon,
        color: isSelected ? ThemeService.primaryColor : null,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? ThemeService.primaryColor : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: ThemeService.primaryColor.withOpacity(0.1),
      onTap: onTap ?? () {
        if (route != null) {
          Navigator.pop(context); // Close drawer
          if (route != currentRoute) {
            Navigator.pushNamed(context, route);
          }
        }
      },
    );
  }
} 