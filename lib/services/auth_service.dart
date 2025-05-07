import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Cache for user profile data to avoid excessive Firestore reads
  Map<String, Map<String, dynamic>> _userProfileCache = {};

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<Map<String, dynamic>> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // Pre-fetch user profile for faster access later
      _fetchUserProfileInBackground(result.user!.uid);
      
      return {
        'success': true,
        'user': result.user,
        'message': 'Successfully signed in'
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many login attempts. Please try again later.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      return {
        'success': false,
        'message': message
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.'
      };
    }
  }

  // Fetch user profile in the background and cache it
  Future<void> _fetchUserProfileInBackground(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userProfileCache[uid] = doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      // Silently handle error since this is a background operation
      print('Error fetching user profile in background: $e');
    }
  }

  // Register with email and password
  Future<Map<String, dynamic>> registerWithEmailAndPassword(
    String email, 
    String password, 
    String fullName
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // Create user profile data
      final userData = {
        'fullName': fullName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      // Create user profile in Firestore
      await _createUserProfile(result.user!.uid, userData);
      
      // Update display name
      await result.user!.updateDisplayName(fullName);
      
      // Cache the profile
      _userProfileCache[result.user!.uid] = Map<String, dynamic>.from(userData);
      if (_userProfileCache[result.user!.uid] != null) {
        _userProfileCache[result.user!.uid]!.remove('createdAt'); // Remove server value
      }
      
      return {
        'success': true,
        'user': result.user,
        'message': 'Account created successfully'
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'weak-password':
          message = 'Password is too weak.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled.';
          break;
        default:
          message = 'An error occurred during registration.';
      }
      return {
        'success': false,
        'message': message
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.'
      };
    }
  }

  // Create user profile in Firestore
  Future<void> _createUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set(data);
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent. Please check your inbox.'
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      return {
        'success': false,
        'message': message
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.'
      };
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update(data);
        
        // Update display name if provided
        if (data.containsKey('fullName')) {
          await user.updateDisplayName(data['fullName']);
        }
        
        // Update cache
        if (_userProfileCache.containsKey(user.uid)) {
          _userProfileCache[user.uid]!.addAll(data);
        }
        
        return {
          'success': true,
          'message': 'Profile updated successfully'
        };
      } else {
        return {
          'success': false,
          'message': 'User not authenticated'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to update profile. Please try again.'
      };
    }
  }

  // Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Check cache first
        if (_userProfileCache.containsKey(user.uid)) {
          return _userProfileCache[user.uid];
        }
        
        // If not in cache, fetch from Firestore
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          // Cache the result
          _userProfileCache[user.uid] = doc.data() as Map<String, dynamic>;
          return _userProfileCache[user.uid];
        }
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final String? uid = _auth.currentUser?.uid;
      await _auth.signOut();
      
      // Clear cache for the user who signed out
      if (uid != null) {
        _userProfileCache.remove(uid);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
  
  // Clear all cached data
  void clearCache() {
    _userProfileCache.clear();
  }
}