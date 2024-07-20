import 'package:e_commerce_app/firebase_options.dart';
import 'package:e_commerce_app/pages/checkout.dart';
import 'package:e_commerce_app/pages/details_screen.dart';
import 'package:e_commerce_app/pages/home.dart';
import 'package:e_commerce_app/pages/sign_in.dart';
import 'package:e_commerce_app/pages/register.dart';
import 'package:e_commerce_app/pages/verify_email.dart';
import 'package:e_commerce_app/provider/cart.dart';
import 'package:e_commerce_app/provider/google_signin.dart';
import 'package:e_commerce_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Cart();
        }),
        ChangeNotifierProvider(create: (context) {
          return GoogleSignInProvider();
        }),
      ],
      child: MaterialApp(
          title: "myApp",
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              } else if (snapshot.hasError) {
                return showSnackBar(context, "Something went wrong");
              } else if (snapshot.hasData) {
                return VerifyEmailPage(); // home() OR verify email
              } else {
                return Login();
              }
            },
          )),
    );
  }
}
