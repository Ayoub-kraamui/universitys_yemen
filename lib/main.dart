import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:university/controller/college_provider.dart';
import 'package:university/controller/theme_provider.dart';
import 'package:university/core/services/services.dart';
import 'package:university/view/screens/University_contents/University-secreen.dart';
import 'package:university/view/screens/auth/login.dart';
import 'package:university/view/screens/auth/signup.dart';
import 'package:university/view/screens/onboardingscreen.dart';
import 'package:university/view/screens/theme_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/screens/filters_screen.dart';
import 'view/screens/tabs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  Widget homeSecreen = prefs.getBool('watched') ?? false
      ? (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? TabsScreen()
          : Login()
      : OnBoardingScreen();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CollegePovider>(
          create: (ctx) => CollegePovider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (ctx) => ThemeProvider(),
        )
      ],
      child: MyApp(homeSecreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  Widget mainScreen;
  MyApp(this.mainScreen);
  @override
  Widget build(BuildContext context) {
    var primaryColor =
        Provider.of<ThemeProvider>(context, listen: true).primaryColor;
    var accentColor =
        Provider.of<ThemeProvider>(context, listen: true).accentColor;
    var tm = Provider.of<ThemeProvider>(context, listen: true).tm;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: tm,
      theme: ThemeData(
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.black87,
        ),
        cardColor: Colors.white,
        shadowColor: Colors.black87,
        backgroundColor: Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: const TextStyle(
                color: Colors.black87,
              ),
              headline6: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
              headline5: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
              headline4: const TextStyle(
                color: Colors.white70,
                fontSize: 22,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
              headline3: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor)
            .copyWith(secondary: accentColor),
      ),
      darkTheme: ThemeData(
        canvasColor: Color.fromRGBO(14, 22, 33, 1),
        fontFamily: 'Raleway',
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white70,
        ),
        cardColor: Color.fromRGBO(35, 34, 39, 1),
        shadowColor: Colors.black87,
        unselectedWidgetColor: Colors.white70,
        backgroundColor: Color.fromRGBO(14, 22, 33, 1),
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText1: const TextStyle(
                color: Colors.white70,
              ),
              headline6: const TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
              headline5: const TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
              headline4: const TextStyle(
                color: Colors.white70,
                fontSize: 22,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
              headline3: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor)
            .copyWith(secondary: accentColor),
      ),
      routes: {
        '/': (ctx) => mainScreen,
        Login.routeName: (context) => Login(),
        SignUp.routeName: (context) => SignUp(),
        TabsScreen.routeName: (ctx) => TabsScreen(),
        //CollegeDetailScreen.routeName: (context) => CollegeDetailScreen(),

        FiltersScreen.routeName: (context) => FiltersScreen(),
        ThemesScreen.routeName: (context) => ThemesScreen(),
        UniversitySecreen.routeName: (context) => UniversitySecreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('University App'),
        ),
        body: null);
  }
}
