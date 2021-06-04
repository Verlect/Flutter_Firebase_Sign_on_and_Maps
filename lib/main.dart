import 'package:flutter/material.dart';
import 'package:signin/authenticate/authenticate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:signin/camera/cameras.dart';
import 'package:signin/home/home.dart';
import 'package:signin/services/googlesignin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:camera/camera.dart';
List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => MyApp(),
      "/maps": (context) => GoogleMaps(cameras),
      "/camera": (context) => CameraScreen(cameras),
    }
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
              create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),

          StreamProvider(
            create: (context) => context.read<AuthenticationService>().authStateChanges,
          ),
        ],
        child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(),
      )
    );
  }
}


class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();

    if(firebaseuser != null){
      return GoogleMaps(cameras);
    }
    return Authenticate();
  }
}
