import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signin/services/googlesignin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          'LOG-IN SCREEN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                onPressed: () async {

                  context.read<AuthenticationService>().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                },
                child: Center(
                  child: Text('Sign In'),
                ),
                color: Colors.blue,
              ),
              SizedBox(
                width: 5.0,
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                onPressed: () {
                  context.read<AuthenticationService>().signUp(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                },
                child: Center(
                  child: Text('Sign Up'),
                ),
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
