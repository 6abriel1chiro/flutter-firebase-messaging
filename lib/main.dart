import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_firebase/firebase_messaging_api.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String _message = '';

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _message = message.notification?.body ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logAppOpen();
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Hello World!'),
              Text('Message: $_message'),
              ElevatedButton(
                onPressed: () async {
                  FirebaseMessaging.instance
                      .getInitialMessage()
                      .then((RemoteMessage? message) {
                    if (message != null) {
                      setState(() {
                        _message = message.notification?.body ?? '';
                      });
                    }
                  });
                },
                child: const Text('notifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
