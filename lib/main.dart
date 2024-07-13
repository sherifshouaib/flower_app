import 'package:e_commerce_app/firebase_options.dart';
import 'package:e_commerce_app/pages/checkout.dart';
import 'package:e_commerce_app/pages/details_screen.dart';
import 'package:e_commerce_app/pages/home.dart';
import 'package:e_commerce_app/pages/sign_in.dart';
import 'package:e_commerce_app/pages/register.dart';
import 'package:e_commerce_app/provider/cart.dart';
import 'package:e_commerce_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (context) {
        return Cart();
      },
      child: MaterialApp(
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
              return Home();
            } else {
              return Login();
            }
          },
        ),
      ),
    );
  }
}
