// ignore_for_file: prefer_const_constructors

import 'package:e_commerce_app/pages/forgot_passowrd.dart';
import 'package:e_commerce_app/pages/register.dart';
import 'package:e_commerce_app/widgets/colors.dart';
import 'package:e_commerce_app/widgets/constants.dart';
import 'package:e_commerce_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isVisible = false;
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  signIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: Text('Sign in'),
      ),
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(33.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 64,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  decoration: decorationTextfield.copyWith(
                    hintText: "Enter Your Email : ",
                    suffixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(
                  height: 33,
                ),
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: isVisible ? false : true,
                  decoration: decorationTextfield.copyWith(
                    hintText: 'Enter Your Password : ',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: isVisible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                  ),
                ),
                SizedBox(
                  height: 33,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await signIn();
                    if (!mounted) return;
                    //   showSnackBar(context, 'Done ... ');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(BTNgreen),
                    padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  ),
                  child: Text(
                    "Sign in",
                    style: TextStyle(fontSize: 19),
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassowrd()));
                  },
                  child: Text(
                    'Forgot password',
                    style: TextStyle(
                        fontSize: 18, decoration: TextDecoration.underline),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Do not have an account?',
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: Text(
                        'sign up',
                        style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
