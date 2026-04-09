import 'package:cabkaro/screens/common/LandingScreen.dart';
import 'package:cabkaro/screens/common/BookingDetailsScreen.dart';
import 'package:cabkaro/screens/driver/DriverScreen.dart';
import 'package:cabkaro/screens/driver/DriverHomeScreen.dart';
import 'package:cabkaro/screens/driver/GOVDetailsScreen.dart';
import 'package:cabkaro/screens/driver/PhotoUploadScreen.dart';
import 'package:cabkaro/screens/user/CarListingScreen.dart';
import 'package:cabkaro/screens/user/MapPickerScreen.dart';
import 'package:cabkaro/screens/user/NotificationsScreen.dart';
import 'package:cabkaro/screens/user/UserDashboardScreen.dart';
import 'package:cabkaro/screens/user/SignupScreen.dart';
import 'package:cabkaro/screens/user/SigninScreen.dart';
import 'package:cabkaro/screens/user/EditProfileScreen.dart';
import 'package:cabkaro/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// =================================================================
// ===================[🙌🏻 JAY JAGANNATH 0!!0 🙏🏻]===================
// =================================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
        title: 'Cabkaro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        ),
        home: const LandingScreen(),
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
          // '/map-picker': (context) => const MapPickerScreen(),
        },
      ),
    );
  }
}