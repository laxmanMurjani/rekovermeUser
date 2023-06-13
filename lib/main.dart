import 'dart:async';
import 'dart:developer';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/ui/splash_screen.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:arbyuser/util/languages.dart';
import 'package:arbyuser/util/remote_config_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    // If you wish to record a "non-fatal" exception, please use `FirebaseCrashlytics.instance.recordFlutterError` instead
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // If you wish to record a "non-fatal" exception, please remove the "fatal" parameter
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'app notification', // id
    'App Related Notification', // title
    playSound: true,
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('wav')
  // playSound: true
);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await RemoteConfigService.setupRemoteConfig();
  FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;
  AppString.googleMapKey =firebaseRemoteConfig.getString("map_key");
  print("sdnmdn===>${AppString.googleMapKey}");
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  DirectionsService.init(AppString.googleMapKey);
  // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  // Stripe.urlScheme = 'flutterstripe';
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );



  late LocationSettings locationSettings;

  if (defaultTargetPlatform == TargetPlatform.android) {
    locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 1),
        //(Optional) Set foreground notification config to keep the app alive
        //when going to the background
        // foregroundNotificationConfig: const ForegroundNotificationConfig(
        //   notificationText:
        //   "ETO Ride Running Background",
        //   notificationTitle: "ETO Ride",
        //   enableWakeLock: true,
        // )
    );
  }
  else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
    locationSettings = AppleSettings(
      accuracy: LocationAccuracy.high,
      activityType: ActivityType.automotiveNavigation,
      distanceFilter: 0,
      pauseLocationUpdatesAutomatically: true,
      // Only set to true if our app will be started up in the background.
      showBackgroundLocationIndicator: false,
    );
  } else {
    locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );
  }

  StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position? position) {
        print(position == null ? 'Unknown' : 'llllat==>${position.latitude.toString()},lonng==> ${position.longitude.toString()}');
      });

  // await Stripe.instance.applySettings();
  runApp(MyApp());



}

class MyApp extends StatefulWidget  {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final UserController _userController = Get.put(UserController());

  final HomeController _homeController = Get.put(HomeController());
  GoogleMapController? _controller;
  @override
  void initState() {
    super.initState();




    WidgetsBinding.instance.addObserver(this);
    // determinePosition();

    FirebaseMessaging.onBackgroundMessage((message) {
      log("RemoteMessage  ===>  12   ${message.data}");
      print("RemoteMessage  ===>  12   ${message.data}");
      return Future.value(true);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? appleNotification = message.notification?.apple;
      log("RemoteMessage  ===>  ${message.data}");
      print("RemoteMessage  ===>  ${message.data}");

      final sound = "wav.wav";

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android:AndroidNotificationDetails(
              channel.id,
              channel.name,
              playSound: true,
              importance: Importance.high,
              sound: RawResourceAndroidNotificationSound(sound.split(".").first),
              icon: "@mipmap/ic_launcher",

            ),
          ),
        );
      } else if (notification != null && appleNotification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
        );
      }
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      // minTextAdapt: true,
      // splitScreenMode: true,
      builder: (BuildContext context, Widget? child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // localizationsDelegates: context.localizationDelegates,
        // supportedLocales: context.supportedLocales,
        // locale: context.locale,
        translations: Languages(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        theme: ThemeData(
            primarySwatch: _primaryColor,
            scaffoldBackgroundColor: AppColors.bgColor,
            fontFamily: 'Sans',
        // appBarTheme: AppBarTheme(
        //   backwardsCompatibility: true, // 1
        //   systemOverlayStyle: SystemUiOverlayStyle.dark, // 2
        //   toolbarTextStyle: TextStyle(color: Colors.black)
        // ),
        ),
        home: child,
      ),
      child: SplashScreen(),
    );
  }

  MaterialColor _primaryColor = MaterialColor(AppColors.primaryColor.value, {
    50: AppColors.primaryColor,
    100: AppColors.primaryColor,
    200: AppColors.primaryColor,
    300: AppColors.primaryColor,
    400: AppColors.primaryColor,
    500: AppColors.primaryColor,
    600: AppColors.primaryColor,
    700: AppColors.primaryColor,
    800: AppColors.primaryColor,
    900: AppColors.primaryColor,
  });
}
