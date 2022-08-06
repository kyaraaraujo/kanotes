# Kanotes

This is a CRUD notes flutter app project with authentication (serverless), for study purpose. In this app is possible to authenticate, add, edit, read and remove notes using Firebasde.


<div align="center">
<br>

| Registering | Log in with notes
| :---: | :---: |
|![adding_items_screenshot](./readme_images/adding_item.png) | ![removing_items_screenshot](readme_images/removing_item.png) |


|     STACKS    |
|      :---:    | 
| ![Dart](https://img.shields.io/badge/-Dart-0175C2?style=flat-round&logo=dart&logoColor=white) ![Flutter](https://img.shields.io/badge/-Flutter-02569B?style=flat-round&logo=flutter&logoColor=white) ![Firebase](https://img.shields.io/badge/-Firebase-black?style=flat-round&logo=firebase&logoColor=FFCA28)  | 




| PROJECT STATUS   |                      Developer                   |
|        :---:     |                         :---:                    |  
|   In progress    |   [Kyara Araújo](https://github.com/kyaraaraujo) | 


<br>



---

## Table of Contents

[Added](#added) &nbsp;&nbsp; | &nbsp;&nbsp; 
[Reminders](#reminders) &nbsp;&nbsp; | &nbsp;&nbsp; 
[How to run](#how-to-run) &nbsp;&nbsp; | &nbsp;&nbsp; 
[To Do](#to-do) &nbsp;&nbsp; | &nbsp;&nbsp; 
[References](#references) &nbsp;&nbsp; 

</div>
<br>


## Added


## Reminders
- `initState()` → executes the code when the Page is rendered. It's also recommended to  `dispose()` to clean memory when the app is finished/closed

`WidgetsFlutterBinding.ensureInitialized` → Inside main() is to make sure that everything that is necessary to be initialized is initialized before the screen is rendered. Ex: Firebase.initializeApp(), [more about binding.](https://docs.flutter.dev/resources/architectural-overview#architectural-layers)

- `.push()` → to bring a Page in front of other
    ```Dart
    Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const WidgetsName())));
    ```
    The route in the builder is an anonymous route because wasn't defined as a route before.

- `.pushNamedAndRemoveUntil()` → It's used to bring a Page and remove the Page before (avoids memory consuming).
    ```Dart
        // constants in another file
        const login = '/login/';

        // inside main()
        routes: {
            login: (context) => const LoginView(),
        }

        // to call the named route
        Navigator.of(context).pushNamedAndRemoveUntil(login, (route) => false)
    ```
    The route in this case is a named route because was defined/known as a route before.

- Can't have a `Scaffold` inside another `Scaffold` (even though they are in different files/widgets)


## **How to run**
- [Install Flutter](https://flutter.dev/) if you don't have it.
- Have an IDE: Visual Studio Code (VSCode), Android Studio, or Xcode
  - Visual Studio Code extensions: 
    - [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
    - [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
- Have a physical smartphone or an emulator (for an Android emulator, can be created in Android Studio or VSCode)
- Need to replace keys in the `firebase_options.dart` with your own keys (by creating a project in Firebase). Keys: apiKey, appId, messagingSenderId, projectId, authDomain, storageBucket, iosClientId, iosBundleId
- Run the app (F5 in VSCode or Run App button in Android Studio)

<br>

### To Do

- [x] ~~Hide api Keys and app IDs~~

- [x] ~~Fix warning: Do not use BuildContexts across async gaps~~

- [ ] Center CircularProgressIndicator in the notes view


## References
- [Free Flutter Course by Vandad Nahavandipoor](https://www.youtube.com/playlist?list=PL6yRaaP0WPkVtoeNIGqILtRAgd3h2CNpT)

- [Firebase Flutter Overview](https://firebase.flutter.dev/docs/overview)
    - [Installing firebase](https://firebase.google.com/docs/cli)
    - [Firebase other sign in methods](https://firebase.flutter.dev/docs/auth/usage/#other-sign-in-methods)
- [Dart and Flutter dependencies](https://pub.dev/)

  

<br>

---
⬆ [Back to top](#kanotes)

<br>
