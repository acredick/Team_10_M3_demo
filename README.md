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
