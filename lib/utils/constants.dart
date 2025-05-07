class AppConstants {
  // Route Names
  static const String ROUTE_SPLASH = '/splash';
  static const String ROUTE_LOGIN = '/login';
  static const String ROUTE_SIGNUP = '/signup';
  static const String ROUTE_FORGOT_PASSWORD = '/forgot-password';
  static const String ROUTE_HOME = '/home';
  static const String ROUTE_PROFILE = '/profile';
  static const String ROUTE_SETTINGS = '/settings';
  
  // University Info
  static const String UNIVERSITY_NAME = 'Amity University Bengaluru';
  static const String UNIVERSITY_TAGLINE = 'Where education meets excellence';
  static const String UNIVERSITY_ADDRESS = 'Bengaluru, Karnataka, India';
  
  // Firebase Collections
  static const String COLLECTION_USERS = 'users';
  static const String COLLECTION_COURSES = 'courses';
  static const String COLLECTION_EVENTS = 'events';
  
  // Validation
  static const int MIN_PASSWORD_LENGTH = 8;
  static const String EMAIL_REGEX = r'^[^@]+@[^@]+\.[^@]+';
  
  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
} 