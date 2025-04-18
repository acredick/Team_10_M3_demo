# Logging In
1. Login as normal.
2. It will not redirect you back to the app. Perform a restart on the app in your IDE.
3. Once the app has restarted, press "Sign In To Your Institution."
4. You should now be automatically signed in.  

# Utilizing the Navigation Bar
## Adding the Navigation Bar
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

## Changing Navigation of the Navigation Bar
Navigation is set up in `lib/widgets/bottom-nav-bar.dart` using routes. To define routes, navigate to `main.dart`.

## Making sure maps work for you.
Ensure that you have set your location on your emulator, to do so on adroid the steps are:
1. Click the elipses in the bottom right
2. Click Location
3. Set your location appropriately.

You make have to hot restart the app once the first time you set your location.
You can also set a route to see the driver move.
