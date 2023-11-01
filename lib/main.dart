import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/locale/app_localizations_delegate.dart';
import 'package:tfleet/route/app_router.dart';
import 'package:tfleet/sqlite/sqlite_db.dart';
import 'package:tfleet/utils/event.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/utils/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tfleet/view/common/notification_page.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// List<CameraDescription> cameras = [];
late double width;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  if (Platform.isAndroid) {
    // Overlay style status bar
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,

      /// Set status bar icon and font color
      /// Brightness.light
      /// Brightness.dark
      statusBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  runApp(const MyHomePage(title: 'ZXY Bus'));
}

final GlobalKey<ScaffoldState> navigatorKey = GlobalKey<ScaffoldState>();

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final ThemeData _themeData = ThemeData(
    primaryColor: TColor.primary,
    scaffoldBackgroundColor: TColor.page,
    indicatorColor: TColor.active,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.white;
          } else {
            return null;
          }
        }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return TColor.danger.withOpacity(0.5);
          } else {
            return TColor.danger;
          }
        }),
      ),
    ),
    accentColor: TColor.primary,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.white.withOpacity(0.5),
    textTheme: const TextTheme(
      bodyText2: TextStyle(
        color: TColor.inactive,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: TColor.inactive,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(
        fontSize: 18,
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: 12),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: TColor.nav,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: TColor.nav,
      selectedItemColor: TColor.active,
      unselectedItemColor: TColor.inactive,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
      ),
    ),
  );
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // from terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      Global.isOpenedByNotification = true;
      // Global.updateUnread(1);
    });

    //background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      // Global.updateUnread(1);
      switch(Global.getRole()) {
        case 1:
          event.emit('PASS_MESS', null, null);
          break;
        case 2:
        case 4:
          event.emit('DRIVER_MESS', null, null);
          break;
        case 3:
          event.emit('SUBCON_MESS', null, null);
          break;
      }
    });

    //foreground
    FirebaseMessaging.onMessage.listen((e) {
      // Global.updateUnread(1);
      switch(Global.getRole()) {
        case 1:
          event.emit('PASS_MESS', null, null);
          break;
        case 2:
        case 4:
          event.emit('DRIVER_MESS', null, null);
          break;
        case 3:
          event.emit('SUBCON_MESS', null, null);
          break;
      }
    });
  }

  Future<bool> isLoggedIn () async {
    await Global.init();
    // await SqliteDb.instance.initDatabase();
    if (Global.clientID() != null && Global.loginStatus == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (_, snapshot) {
        String route = AppRouter.unknownRoleRoute;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data!) {
            switch(Global.getRole()) {
              case 1:
                route = AppRouter.passengerLoggedInRoute;
                break;
              case 2:
              case 4:
                route = AppRouter.driverLoggedInRoute;
                break;
              case 3:
                route = AppRouter.subconLoggedInRoute;
                break;
            }
            return GetMaterialApp(
              title: 'T Fleet',
              theme: _themeData,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('zh')
              ],
              initialRoute: route,
              unknownRoute: AppRouter.unknownRoute,
              getPages: AppRouter.getPages,
            );
          } else {
            return GetMaterialApp(
              title: AppLocalizations.of(context)?.login ?? 'Login',
              theme: _themeData,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('zh')
              ],
              initialRoute: AppRouter.initialRoute,
              unknownRoute: AppRouter.unknownRoute,
              getPages: AppRouter.getPages,
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
