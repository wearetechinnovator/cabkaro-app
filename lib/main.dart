import 'package:cabkaro/controllers/auth_check_controller.dart';
import 'package:cabkaro/controllers/car_details_controller.dart';
import 'package:cabkaro/controllers/driver/driver_ride_controller.dart';
import 'package:cabkaro/controllers/driver/driver_signup_controller.dart';
import 'package:cabkaro/controllers/driver/driver_verify_otp_controller.dart';
import 'package:cabkaro/controllers/driver_details_controller.dart';
import 'package:cabkaro/controllers/user/change_password_controller.dart';
import 'package:cabkaro/controllers/edit_profile_controller.dart';
import 'package:cabkaro/controllers/user/login_controller.dart';
import 'package:cabkaro/controllers/user/review_controller.dart';
import 'package:cabkaro/controllers/user/ride_controller.dart';
import 'package:cabkaro/controllers/user/verify_otp_controller.dart';
import 'package:cabkaro/controllers/user_controller.dart';
import 'package:cabkaro/controllers/vendor_controller.dart';
import 'package:cabkaro/providers/socket_provider.dart';
import 'package:cabkaro/screens/common/booking_details_screen.dart';
import 'package:cabkaro/screens/common/change_password_screen.dart';
import 'package:cabkaro/screens/common/login_screen.dart';
import 'package:cabkaro/screens/common/splash_screen.dart';
import 'package:cabkaro/screens/driver/driver_booked_cab_screen.dart';
import 'package:cabkaro/screens/driver/driver_edit_profile_screen.dart';
import 'package:cabkaro/screens/driver/vendor_home_screen.dart';
import 'package:cabkaro/screens/driver/driver_notifications_screen.dart';
import 'package:cabkaro/screens/driver/driver_profile_screen.dart';
import 'package:cabkaro/screens/driver/driver_ride_history_screen.dart';
import 'package:cabkaro/screens/driver/gov_details_screen.dart';
import 'package:cabkaro/screens/driver/listed_car_deatils_screen.dart';
import 'package:cabkaro/screens/driver/listed_driver_details_screen.dart';
import 'package:cabkaro/screens/driver/ongoing_rides_screen.dart';
import 'package:cabkaro/screens/driver/photo_upload_screen.dart';
import 'package:cabkaro/screens/user/available_cabs_screen.dart';
import 'package:cabkaro/screens/user/booked_cab_screen.dart';
import 'package:cabkaro/screens/user/user_home_screen.dart';
import 'package:cabkaro/screens/user/notifications_screen.dart';
import 'package:cabkaro/screens/user/user_profile_screen.dart';
import 'package:cabkaro/screens/user/user_details_screen.dart';
import 'package:cabkaro/screens/user/signin_screen.dart';
import 'package:cabkaro/screens/user/user_edit_profile_screen.dart';
import 'package:cabkaro/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// ===================================================
// ============[🙌🏻 JAY JAGANNATH 0!!0 🙏🏻]============
// ===================================================

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
        ChangeNotifierProvider(create: (_) => EditProfileController()),
        ChangeNotifierProvider(create: (_) => RideController()),
        ChangeNotifierProvider(create: (_) => SocketProvider()),
        ChangeNotifierProvider(create: (_) => ReviewController()),
        ChangeNotifierProvider(create: (_) => DriverSignupController()),
        ChangeNotifierProvider(create: (_) => DriverVerifyOtpController()),
        ChangeNotifierProvider(create: (_) => DriverRideController()),
        ChangeNotifierProvider(create: (_) => ChangePasswordController()),

        ChangeNotifierProvider(create: (_) => AuthCheckController()),
        ChangeNotifierProvider(create: (_) => VendorController()),
        ChangeNotifierProvider(create: (_) => CarDetailsController()),
        ChangeNotifierProvider(create: (_) => DriverDetailsController()),
        ChangeNotifierProvider(create: (_) => UserController()),
      ],
      child: MaterialApp(
        title: 'Cabkaro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        ),

        // home: const SplashScreen(),
        // home: AvailableCabsScreen(rideId: '2',),
        home: BookedCabScreen(),
        // home: OngoingRidesScreen(),
        routes: {
          '/signup': (context) => const UserDetailsScreen(),
          '/booking-details': (context) => const BookingDetailsScreen(),
          '/driver': (context) => const LoginScreen(),
          '/driver-home': (context) => const VendorHomeScreen(),
          '/driver-ride-history': (context) => const RideHistoryScreen(),
          '/driver-notifications': (context) =>
              const DriverNotificationsScreen(),
          '/driver-profile': (context) => const DriverProfileScreen(),
          '/gov-details': (context) => const GOVDetailsScreen(),
          '/photo-upload': (context) => const PhotoUploadScreen(),
          '/listing': (context) => const UserHomeScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/dashboard': (context) => const UserProfileScreen(),
          '/signin': (context) => SigninScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
          '/driver-notification': (context) =>
              const DriverNotificationsScreen(),
          '/driver-edit-profile': (context) => const DriverEditProfileScreen(),
          '/change-password': (context) => const ChangePasswordScreen(),
          '/car-details': (context) => const ListedCarDetailsScreen(),
          '/driver-details-listing': (context) =>
              const ListedDriverDetailsScreen(),
          '/ongoing-rides': (context) => const OngoingRidesScreen(),
        },
      ),
    );
  }
}
