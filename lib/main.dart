import 'package:cabkaro/controllers/auth_check_controller.dart';
<<<<<<< HEAD
import 'package:cabkaro/controllers/driver/driver_ride_controller.dart';
import 'package:cabkaro/controllers/driver/driver_signup_controller.dart';
import 'package:cabkaro/controllers/driver/driver_verify_otp_controller.dart';
=======
import 'package:cabkaro/controllers/car_details_controller.dart';
import 'package:cabkaro/controllers/driver/driver_ride_controller.dart';
import 'package:cabkaro/controllers/driver/driver_signup_controller.dart';
import 'package:cabkaro/controllers/driver/driver_verify_otp_controller.dart';
import 'package:cabkaro/controllers/driver_details_controller.dart';
>>>>>>> a64f8e0 (Edit vendor and user profile)
import 'package:cabkaro/controllers/user/change_password_controller.dart';
import 'package:cabkaro/controllers/edit_profile_controller.dart';
import 'package:cabkaro/controllers/user/login_controller.dart';
import 'package:cabkaro/controllers/user/review_controller.dart';
import 'package:cabkaro/controllers/user/ride_controller.dart';
<<<<<<< HEAD
import 'package:cabkaro/controllers/user/signup_controller.dart';
import 'package:cabkaro/controllers/user/verify_otp_controller.dart';
=======
import 'package:cabkaro/controllers/user/verify_otp_controller.dart';
import 'package:cabkaro/controllers/user_controller.dart';
>>>>>>> a64f8e0 (Edit vendor and user profile)
import 'package:cabkaro/controllers/vendor_controller.dart';
import 'package:cabkaro/providers/socket_provider.dart';
import 'package:cabkaro/screens/common/booking_details_screen.dart';
import 'package:cabkaro/screens/common/change_password_screen.dart';
import 'package:cabkaro/screens/common/login_screen.dart';
import 'package:cabkaro/screens/common/splash_screen.dart';
import 'package:cabkaro/screens/driver/driver_edit_profile_screen.dart';
<<<<<<< HEAD
import 'package:cabkaro/screens/driver/driver_home_screen.dart';
import 'package:cabkaro/screens/driver/driver_no_ride_screen.dart';
=======
import 'package:cabkaro/screens/driver/vendor_home_screen.dart';
>>>>>>> a64f8e0 (Edit vendor and user profile)
import 'package:cabkaro/screens/driver/driver_notifications_screen.dart';
import 'package:cabkaro/screens/driver/driver_profile_screen.dart';
import 'package:cabkaro/screens/driver/driver_ride_history_screen.dart';
import 'package:cabkaro/screens/driver/gov_details_screen.dart';
import 'package:cabkaro/screens/driver/listed_car_deatils_screen.dart';
import 'package:cabkaro/screens/driver/listed_driver_details_screen.dart';
import 'package:cabkaro/screens/driver/ongoing_rides_screen.dart';
import 'package:cabkaro/screens/driver/photo_upload_screen.dart';
<<<<<<< HEAD
import 'package:cabkaro/screens/user/car_listing_screen.dart';
import 'package:cabkaro/screens/user/driver_searching_screen.dart';
import 'package:cabkaro/screens/user/notifications_screen.dart';
import 'package:cabkaro/screens/user/user_profile_screen.dart';

import 'package:cabkaro/screens/user/signin_screen.dart';
import 'package:cabkaro/screens/user/user_edit_profile_screen.dart';
import 'package:cabkaro/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

<<<<<<< HEAD
// ===================================================
// ============[🙌🏻 JAY JAGANNATH 0!!0 🙏🏻]============
// ===================================================
=======
// ========================================================
// ===============[🙏🏻 JAY JAGANNATH 0!!0 🙏🏻]==============
// ========================================================
>>>>>>> 5c2a44a (minor changes)
=======
import 'package:cabkaro/screens/user/user_home_screen.dart';
import 'package:cabkaro/screens/user/notifications_screen.dart';
import 'package:cabkaro/screens/user/user_profile_screen.dart';
import 'package:cabkaro/screens/user/user_details_screen.dart';
import 'package:cabkaro/screens/user/signin_screen.dart';
import 'package:cabkaro/screens/user/user_edit_profile_screen.dart';
import 'package:cabkaro/providers/location_provider.dart';
import 'package:cabkaro/widgets/test_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// ===================================================
// ============[🙌🏻 JAY JAGANNATH 0!!0 🙏🏻]============
// ===================================================
>>>>>>> a64f8e0 (Edit vendor and user profile)

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
<<<<<<< HEAD
        ChangeNotifierProvider(create: (_) => SignupController()),
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
=======
        ChangeNotifierProvider(create: (_) => CarDetailsController()),
        ChangeNotifierProvider(create: (_) => DriverDetailsController()),
        ChangeNotifierProvider(create: (_) => UserController()),
>>>>>>> a64f8e0 (Edit vendor and user profile)
      ],
      child: MaterialApp(
        title: 'Cabkaro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        ),
<<<<<<< HEAD
<<<<<<< HEAD

        home: const SplashScreen(),
=======
        // home: LoginScreen(),
        // home: DriverNoRidesScreen(),
        // home: DriverHomeScreen(),
        // home: CarDetailsScreenScreen(),
        // home: CarListingScreen(),
        // home: BookingDetailsScreen(),
        // home: DriverSearchingScreen(),
        // home: SplashScreen(),
        home: DriverNoRidesScreen(),
>>>>>>> 5c2a44a (minor changes)
        routes: {

          '/booking-details': (context) => const BookingDetailsScreen(),
          '/driver': (context) => const LoginScreen(),
          '/driver-home': (context) => const DriverHomeScreen(),
=======

        // home: const SplashScreen(),
        home: SplashScreen(),
        routes: {
          '/signup': (context) => const UserDetailsScreen(),
          '/booking-details': (context) => const BookingDetailsScreen(),
          '/driver': (context) => const LoginScreen(),
          '/driver-home': (context) => const VendorHomeScreen(),
>>>>>>> a64f8e0 (Edit vendor and user profile)
          '/driver-ride-history': (context) => const RideHistoryScreen(),
          '/driver-notifications': (context) =>
              const DriverNotificationsScreen(),
          '/driver-profile': (context) => const DriverProfileScreen(),
          '/gov-details': (context) => const GOVDetailsScreen(),
          '/photo-upload': (context) => const PhotoUploadScreen(),
<<<<<<< HEAD
          '/listing': (context) => const CarListingScreen(),
=======
          '/listing': (context) => const UserHomeScreen(),
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
