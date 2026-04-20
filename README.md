# Cabkaro | Flutter Cab Booking App

**Cabkaro** is a professional-grade **Flutter-based cab booking application** designed to provide a seamless ride-sharing experience for both users and drivers. This open-source project features a robust architecture using the **Provider** package for state management, **Google Maps API** for real-time tracking, and **Socket.io** for instant communication.

## Key Features

* **Dual Dashboards:** Tailored interfaces for both **Passengers** and **Drivers**.
* **Real-time GPS Tracking:** Integrated **Google Maps** for live ride tracking and accurate geocoding.
* **Secure Authentication:** Complete user flow including **Firebase/OTP verification**, Sign In, and Sign Up.
* **Advanced Ride Management:** Specialized screens for vehicle listings, booking details, and ride history.
* **Profile & Security:** Comprehensive profile management and permission handling for user data.
* **Instant Notifications:** Real-time alert system to keep users updated on ride status.

## Tech Stack

* **Frontend Framework:** Flutter (SDK ^3.10.7)
* **State Management:** Provider (Clean Architecture)
* **Maps & Location:** Google Maps Flutter, Geocoding, Location Services
* **Real-time Backend:** Socket.io Client
* **UI/UX:** Flutter Animate, Google Fonts, Blurry Container
* **Local Storage:** Shared Preferences

## Project Structure

The codebase is organized for scalability and readability:

* **Controllers:** Business logic for Auth, OTP, Profile, Rides, and Reviews.
* **Providers:** Global state management for location and user data.
* **Screens:** Categorized into `Common` (Splash/Booking), `User` (Dashboard/Listings), and `Driver` (KYC/Photo Upload).


