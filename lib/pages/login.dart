import 'package:e_commerce_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(33.0),
          child: Column(
            children: [
              SizedBox(
                height: 64,
              ),
              MyTextField(
                textInputTypeee: TextInputType.emailAddress,
                isPassword: false,
                hinttexttt: 'Enter your Email : ',
              ),
              SizedBox(
                height: 33,
              ),
              MyTextField(
                textInputTypeee: TextInputType.text,
                isPassword: true,
                hinttexttt: 'Enter your Password : ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
