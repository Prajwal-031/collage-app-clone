import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import '../services/theme_service.dart';
import '../utils/constants.dart';
import '../widgets/app_navbar.dart';
import '../widgets/navigation_drawer.dart' as app_drawer;
import '../widgets/university_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final AuthService _auth = AuthService();
  final NavigationService _navigationService = NavigationService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  
  @override
  bool get wantKeepAlive => true; // Keep this widget alive when navigating
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Reduced animation time
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _loadUserProfile();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserProfile() async {
    // Check if we already have the user data from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user != null && user.displayName != null && _userProfile == null) {
      // If we have basic user info, show it immediately
      setState(() {
        _isLoading = false;
      });
      _animationController.forward();
      
      // Then load the full profile in the background
      _userProfile = await _auth.getUserProfile();
      if (mounted) {
        setState(() {});
      }
    } else {
      // Otherwise load the profile normally
      setState(() {
        _isLoading = true;
      });
      
      final userProfile = await _auth.getUserProfile();
      
      if (mounted) {
        setState(() {
          _userProfile = userProfile;
          _isLoading = false;
        });
        
        _animationController.forward();
      }
    }
  }
  
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
  
  Widget _buildUserInfo() {
    User? user = FirebaseAuth.instance.currentUser;
    final String userName = user?.displayName ?? _userProfile?['fullName'] ?? 'Student';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: ThemeService.secondaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          userName,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: ThemeService.textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome to ${AppConstants.UNIVERSITY_NAME}',
          style: TextStyle(
            fontSize: 16,
            color: ThemeService.secondaryTextColor,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeService.secondaryTextColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      appBar: const AppNavbar(
        showLogo: true,
      ),
      drawer: const app_drawer.NavigationDrawer(
        currentRoute: AppConstants.ROUTE_HOME,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User greeting and university name
                      _buildUserInfo(),
                      
                      const SizedBox(height: 32),
                      
                      // University Logo and Motto - Prebuilt widget for performance
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: ThemeService.universityPrimary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          children: [
                            UniversityLogo(
                              size: 70,
                              textColor: Colors.white,
                              showTagline: true,
                            ),
                            SizedBox(height: 16),
                            Text(
                              AppConstants.UNIVERSITY_ADDRESS,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Dashboard Items
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ThemeService.textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Using const widgets where possible for performance
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          _buildDashboardCard(
                            title: 'Courses',
                            subtitle: 'View your courses',
                            icon: Icons.book_outlined,
                            color: Colors.blueAccent,
                            onTap: () {
                              // Navigate to courses
                            },
                          ),
                          _buildDashboardCard(
                            title: 'Calendar',
                            subtitle: 'Schedule & Events',
                            icon: Icons.calendar_today_outlined,
                            color: Colors.orangeAccent,
                            onTap: () {
                              // Navigate to calendar
                            },
                          ),
                          _buildDashboardCard(
                            title: 'Library',
                            subtitle: 'Resources & Books',
                            icon: Icons.local_library_outlined,
                            color: Colors.purpleAccent,
                            onTap: () {
                              // Navigate to library
                            },
                          ),
                          _buildDashboardCard(
                            title: 'Profile',
                            subtitle: 'Account Settings',
                            icon: Icons.person_outline,
                            color: Colors.teal,
                            onTap: () {
                              _navigationService.navigateTo(AppConstants.ROUTE_PROFILE);
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Announcements
                      _buildAnnouncementsWidget(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
  
  // Extracted to a separate method for better organization
  Widget _buildAnnouncementsWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.campaign_outlined,
                color: ThemeService.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Announcements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeService.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Sample announcements
          _buildAnnouncementItem(
            title: 'Welcome to the New Semester',
            date: 'August 15, 2023',
            isNew: true,
          ),
          const Divider(height: 24),
          _buildAnnouncementItem(
            title: 'Library Hours Extended for Finals Week',
            date: 'July 28, 2023',
            isNew: false,
          ),
          const Divider(height: 24),
          _buildAnnouncementItem(
            title: 'Campus Maintenance Scheduled',
            date: 'July 20, 2023',
            isNew: false,
          ),
          
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {
                // View all announcements
              },
              child: Text(
                'View All Announcements',
                style: TextStyle(
                  color: ThemeService.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnnouncementItem({
    required String title,
    required String date,
    required bool isNew,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 6, right: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isNew ? Colors.red : Colors.transparent,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
                  color: ThemeService.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeService.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: ThemeService.secondaryTextColor,
          ),
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.only(left: 8),
          onPressed: () {
            // View announcement detail
          },
        ),
      ],
    );
  }
}
