import 'package:cabkaro/controllers/user/edit_profile_controller.dart';
import 'package:cabkaro/controllers/user/login_controller.dart';
import 'package:cabkaro/controllers/user/review_controller.dart';
import 'package:cabkaro/controllers/user/ride_controller.dart';
import 'package:cabkaro/controllers/user/signup_controller.dart';
import 'package:cabkaro/controllers/user/verify_otp_controller.dart';
import 'package:cabkaro/screens/common/booking_details_screen.dart';
import 'package:cabkaro/screens/common/splash_screen.dart';
import 'package:cabkaro/screens/driver/driver_screen.dart';
import 'package:cabkaro/screens/driver/driver_home_screen.dart';
import 'package:cabkaro/screens/driver/gov_details_screen.dart';
import 'package:cabkaro/screens/driver/photo_upload_screen.dart';
import 'package:cabkaro/screens/user/car_listing_screen.dart';
import 'package:cabkaro/screens/user/notifications_screen.dart';
import 'package:cabkaro/screens/user/user_dashboard_screen.dart';
import 'package:cabkaro/screens/user/signup_screen.dart';
import 'package:cabkaro/screens/user/signin_screen.dart';
import 'package:cabkaro/screens/user/edit_profile_screen.dart';
import 'package:cabkaro/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// =================================================================
// ===================[🙌🏻 JAY JAGANNATH 0!!0 🙏🏻]===================
// =================================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => VerifyOtpController()),
        ChangeNotifierProvider(create: (_) => SignupController()),
        ChangeNotifierProvider(create: (_) => EditProfileController()),
        ChangeNotifierProvider(create: (_) => RideController()),
        ChangeNotifierProvider(create: (_) => ReviewController()),
      ],
      child: MaterialApp(
        title: 'Cabkaro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        ),
        home: const SplashScreen(),
        routes: {
          '/signup': (context) => const SignupScreen(),
          '/booking-details': (context) => const BookingDetailsScreen(),
          '/driver': (context) => const DriverScreen(),
          '/driver-home': (context) => const DriverHomeScreen(),
          '/gov-details': (context) => const GOVDetailsScreen(),
          '/photo-upload': (context) => const PhotoUploadScreen(),
          '/listing': (context) => const CarListingScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/dashboard': (context) => const UserDashboardScreen(),
          '/signin': (context) => SigninScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
        },
      ),
    );
  }
}
