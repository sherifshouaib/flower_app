import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/pages/sign_in.dart';
import 'package:e_commerce_app/widgets/colors.dart';
import 'package:e_commerce_app/widgets/constants.dart';
import 'package:e_commerce_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' show basename;

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isVisible = true;
  final _formKey = GlobalKey<FormState>();
  File? imgPath;
  String? imgName;

  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final usernameController = TextEditingController();
  final ageController = TextEditingController();
  final titleController = TextEditingController();

  bool isPassword8Char = false;
  bool isPasswordHas1Number = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;

  uploadImage2Screen(ImageSource source) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          String imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
          print(imgName);
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage2Screen(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      'From Camera',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () async {
                  await uploadImage2Screen(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      'From Gallery',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  onPasswordChanged(String password) {
    isPassword8Char = false;
    isPasswordHas1Number = false;
    hasUppercase = false;
    hasLowercase = false;
    hasSpecialCharacters = false;

    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        isPassword8Char = true;
      }

      if (password.contains(RegExp(r'[0-9]'))) {
        isPasswordHas1Number = true;
      }

      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }

      if (password.contains(RegExp(r'[a-z]'))) {
        hasLowercase = true;
      }
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacters = true;
      }
    });
  }

  register() async {
    setState(() {
      isLoading = true;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

// Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref('users-imgs/$imgName');
      await storageRef.putFile(imgPath!);
      String urll = await storageRef.getDownloadURL();



      print(credential.user!.uid);
      CollectionReference users =
          FirebaseFirestore.instance.collection('userSSS');

      users
          .doc(credential.user!.uid)
          .set({
            'imgLink' : urll,
            'username': usernameController.text,
            'age': ageController.text,
            'title': titleController.text,
            'email': emailController.text,
            'pass': passwordController.text,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The account already exists for that email.");
      } else {
        showSnackBar(context, "ERROR - Please try again later");
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    ageController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        elevation: 0,
        backgroundColor: appbarGreen,
      ),
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(33.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(125, 78, 91, 110),
                    ),
                    child: Stack(
                      children: [
                        imgPath == null
                            ? CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 225, 225, 225),
                                radius: 71,
                                //backgroundImage: AssetImage('assets/images/avatar.png'),
                                backgroundImage:
                                    AssetImage('assets/images/avatar.png'),
                              )
                            : ClipOval(
                                child: Image.file(
                                  imgPath!,
                                  width: 145,
                                  height: 145,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Positioned(
                          left: 99,
                          bottom: -10,
                          child: IconButton(
                            onPressed: () {
                              //  uploadImage2Screen();
                              showmodel();
                            },
                            icon: const Icon(Icons.add_a_photo),
                            color: Color.fromARGB(255, 94, 115, 128),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 33,
                  ),
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your username : ",
                      suffixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                      hintText: 'Enter Your age : ',
                      suffixIcon: Icon(Icons.pest_control_rodent),
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                      hintText: 'Enter Your title : ',
                      suffixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  TextFormField(
                    // we return "null" when something is valid
                    validator: (email) {
                      return email!.contains(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                          ? null
                          : "Enter a valid email";
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Email : ",
                      suffixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  TextFormField(
                    onChanged: (password) {
                      onPasswordChanged(password);
                    },
                    validator: (value) {
                      return value!.length < 8
                          ? "Enter at least 8 characters"
                          : null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: isVisible ? true : false,
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
                    height: 12,
                  ),
                  Row(
                    children: [
                      Container(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPassword8Char ? Colors.green : Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 161, 159, 159)),
                        ),
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        'At least 8 characters',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPasswordHas1Number
                              ? Colors.green
                              : Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 161, 159, 159)),
                        ),
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        'At least 1 number',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasUppercase ? Colors.green : Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 161, 159, 159)),
                        ),
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        'Has Uppercase',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasLowercase ? Colors.green : Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 161, 159, 159)),
                        ),
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        'Has Lowercase',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasSpecialCharacters
                              ? Colors.green
                              : Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 161, 159, 159)),
                        ),
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        'Has Special Characters',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 33,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && imgName != null && imgPath != null ) {
                        await register();
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      } else {
                        showSnackBar(context, "ERROR");
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(BTNgreen),
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Register",
                            style: TextStyle(fontSize: 19),
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
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Text(
                          'sign in',
                          style: TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
