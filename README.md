# Cabkaro

Cabkaro is a Flutter-based cab booking application designed to provide a seamless transportation experience for both users and drivers. The app utilizes a robust architecture featuring the Provider package for state management and integrates essential services such as Google Maps and real-time socket communications.

## Key Features

* **User & Driver Dashboards**: Separate, tailored interfaces for passengers and service providers.
* **Real-time Tracking**: Integration with Google Maps for accurate location services and ride tracking.
* **Authentication System**: Complete flow including Sign In, Sign Up, and OTP verification.
* **Profile Management**: Functionality for users to view and update their personal information.
* **Ride Management**: Specialized screens for car listings, booking details, and ride history.
* **Notifications**: A dedicated system to keep users informed about ride status and updates.

## Tech Stack

* **Framework**: Flutter (SDK version ^3.10.7)
* **State Management**: Provider
* **Location Services**: Google Maps Flutter, Geocoding
* **Real-time Communication**: Socket.io Client
* **UI Components**: Flutter Animate, Google Fonts, Blurry Container
* **Utilities**: Shared Preferences, Image Picker, Permission Handler, File Picker

## Project Structure

The application's core logic is organized into specialized controllers and providers:

* **Controllers**: Handle business logic for Login, OTP Verification, Signup, Profile Editing, Rides, and Reviews.
* **Providers**: Manage global state, specifically for location data.
* **Screens**: Organized into common (Splash, Booking Details), user-specific (Dashboard, Listings), and driver-specific (Government Details, Photo Upload) directories.

## Getting Started

### Prerequisites

* Flutter SDK installed on your machine.
* A configured emulator or physical device.

### Installation

1.  Clone the repository.
2.  Navigate to the project directory.
3.  Install dependencies:
    ```bash
    flutter pub get
    ```
4.  Run the application:
    ```bash
    flutter run
    ```

## Asset Configuration

The project utilizes several asset directories for its user interface:
* `assets/icons/`: Stores SVG and PNG icons used throughout the app.
* `assets/images/`: Contains UI backgrounds, car images, and branding elements.
