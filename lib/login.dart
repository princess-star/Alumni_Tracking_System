

import 'package:alumni_tracking_system/admin/admin_homepage.dart';
import 'package:alumni_tracking_system/constant.dart';
import 'package:alumni_tracking_system/admin/homepage.dart';
import 'package:alumni_tracking_system/register.dart';
import 'package:alumni_tracking_system/user/user_homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool visible = false;
  final _formkey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: const Center(
                        child: Image(
                          image: AssetImage(
                            "res/pic/svfclogo.png",
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Login to your Account',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: customFormField(
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        controller: email,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: customFormField(
                        controller: password,
                        labelText: 'Password',
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return loading
                              ? MaterialButton(
                                  onPressed: () async {
                                    if (email.text.isNotEmpty) {
                                      if (password.text.isNotEmpty) {
                                        setState(() {
                                          loading = !loading;
                                        });
                                      } else {
                                        newSnackBar(context,
                                            title:
                                                'Email and Password Required!');
                                      }
                                    } else {
                                      newSnackBar(context,
                                          title: 'Email Required!');
                                    }

                                    try {
                                      User? user = FirebaseAuth.instance.currentUser;
                                    var kk = FirebaseFirestore.instance
                                          .collection('users_account')
                                          .doc(user!.uid)
                                          .get()
                                          .then((DocumentSnapshot documentSnapshot) {
                                        if (documentSnapshot.exists) {
                                          if (documentSnapshot.get('rool') == "Teacher") {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>  Teacher(),
                                              ),
                                            );
                                          }else{
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>  Student(),
                                              ),
                                            );
                                          }
                                        } else {
                                          print('Document does not exist on the database');
                                        }
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        newSnackBar(context,
                                            title:
                                                'No user found for that email.');
                                        setState(() {
                                          loading = !loading;
                                        });
                                      } else if (e.code == 'wrong-password') {
                                        newSnackBar(context,
                                            title:
                                                'Wrong password provided for that user.');
                                        setState(() {
                                          loading = !loading;
                                        });
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: pink1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 15, 0, 15),
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(color: white),
                                        ),
                                      ),
                                    ],
                                  ))
                              : Center(
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        visible = true;
                                      });
                                    },
                                    shape: const CircleBorder(),
                                    color: pink1,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: white,
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPasswordPage();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserRegister(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  customFormField({
    controller,
    labelText,
    keyboardType,
    textInputAction,
    obscureText,
  }) {
    return Material(
      elevation: 2,
      shadowColor: black,
      color: white,
      borderRadius: BorderRadius.circular(5.0),
      child: TextFormField(
        autofocus: false,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        controller: controller,
        cursorColor: black,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: black),
          contentPadding: const EdgeInsets.all(8),
          border: InputBorder.none,
        ),
      ),
    );
  }
}


