# DormDash
A cross-platform mobile app built with Flutter that lets students pick up and deliver food orders for each other on campus: a peer-to-peer delivery system designed to reduce wait times and increase convenience.

## 🚀 Overview

DormDash was created as part of a capstone project with a team of 5. The app was inspired by our frustration with campus dining apps like MobileID/GET, which don’t support delivery. We validated our idea through surveys and built DormDash to enable students to help each other out by delivering food orders from campus restaurants.

## Features
- Authentication and role selection (customer/deliverer)
- Order lifecycle: select → pickup → deliver
- Real-time updates via Firestore
- In-app chat between customer and deliverer
- Google Maps for routing and live location
- Earnings summary for deliverers
- Reusable UI components (DeliveryDetailsCard, bottom nav)

## Tech Stack
- Frontend: Flutter (Dart)
- Backend: Firebase (Auth, Firestore)
- Collaboration: Git, Github
- Maps: google_maps_flutter (+ GoogleMaps iOS SDK)
- Packages: slide_to_act, location, geocoding, url_launcher

## How to Run
1. Clone the repo
2. Install dependencies
   ```
   flutter pub get
   ```
3. IOS Setup (CocoaPods)
   ```
   sudo gem install cocoapods
   cd ios
   pod install
   cd ..
   ```
4. Set up Firebase
- Go to the Firebase Console and create a new project.
- Enable Authentication (Email/Password) and Cloud Firestore.
- Download your platform-specific configuration files:
   - Android: Place google-services.json in android/app/
   - iOS: Place GoogleService-Info.plist in ios/Runner/
5. Google Maps API Key Setup
- Enable the Maps SDK for Android and Maps SDK for iOS in the Google Cloud Console.
- Add your API key to the platform files:
  - Android: In android/app/src/main/AndroidManifest.xml:
    ```
    <meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
    ```
  - iOS: In ios/Runner/AppDelegate.swift, initialize Google Maps:
    ```
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
    ```
6. Run on emulator or device
   ```
   flutter run
   ```

## Usage Notes & Developer Tips
### Logging In
1. Login as normal.
2. It will not redirect you back to the app. Perform a restart on the app in your IDE.
3. Once the app has restarted, press "Sign In To Your Institution."
4. You should now be automatically signed in.  

### Utilizing the Navigation Bar
#### Adding the Navigation Bar
1. Import `lib/widgets/bottom-nav-bar.dart` to your file.
2. When using `Navigator.push()` in your file, use this to include a bottom navigation bar:
   ```
     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: DESTINATION_PAGE
          bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: 0,
            onItemTapped: (index) {
            },
            userType: USER_TYPE,
          ),
        ),
      ),
    );
 Change `DESTINATION_PAGE` and `USER_TYPE` accordingly. 
 > Note: `USER_TYPE` can be either `"customer"` or `"deliverer"`.

### Changing Navigation of the Navigation Bar
Navigation is set up in `lib/widgets/bottom-nav-bar.dart` using routes. To define routes, navigate to `main.dart`.

### Making sure maps work for you.
Ensure that you have set your location on your emulator, to do so on adroid the steps are:
1. Click the elipses in the bottom right
2. Click Location
3. Set your location appropriately.

You make have to hot restart the app once the first time you set your location.
You can also set a route to see the driver move.
