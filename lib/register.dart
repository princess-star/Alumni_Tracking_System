

import 'package:alumni_tracking_system/constant.dart';
import 'package:alumni_tracking_system/admin/homepage.dart';
import 'package:alumni_tracking_system/login.dart';
import 'package:alumni_tracking_system/verification/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({Key? key}) : super(key: key);

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  _UserRegisterState();

  bool showProgress = false;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  var options = [
    'Student',
    'Teacher',
  ];
  var _currentItemSelected = "Student";
  var rool = "Student";

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: pink1,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: const Center(
                    child: Image(
                      image: AssetImage("res/pic/svfclogo.png"),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Create your Account',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: customFormFeild(
                    labelText: 'Name',
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    controller: name,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: customFormFeild(
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    controller: email,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: customFormFeild(
                    controller: password,
                    labelText: 'Password',
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return loading
                          ? MaterialButton(
                          onPressed: () async {
                            if (name.text.isNotEmpty) {
                              if (email.text.isNotEmpty) {
                                if (password.text.isNotEmpty) {
                                  setState(() {
                                    loading = !loading;
                                  });
                                } else {
                                  newSnackBar(context,
                                      title: 'Password Required!');
                                }
                              } else {
                                newSnackBar(context,
                                    title: 'Email Required!');
                              }
                            } else {
                              newSnackBar(context, title: 'Name Required!');
                            }

                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text)
                                  .then((value) async {
                                await FirebaseFirestore.instance
                                    .collection("users_account")
                                    .doc(value.user!.uid)
                                    .set({
                                  'uid': value.user!.uid,
                                  'name': name.text,
                                  'email': email.text,
                                  'rool': rool,
                                }).then((value) {
                                  email.clear();
                                  name.clear();
                                  password.clear();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const LoginPage(),
                                    ),
                                  );
                                  setState(() {
                                    loading = !loading;
                                  });
                                });
                              });
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                newSnackBar(context,
                                    title:
                                    'The password provided is too weak.');
                                setState(() {
                                  loading = !loading;
                                });
                              } else if (e.code == 'email-already-in-use') {
                                newSnackBar(context,
                                    title:
                                    'The account already exists for that email.');
                                setState(() {
                                  loading = !loading;
                                });
                              }
                            } catch (e) {
                              newSnackBar(context, title: e);
                              setState(() {
                                loading = !loading;
                              });
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
                                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(color: white),
                                ),
                              ),
                            ],

                          ))

                          : Center(
                        child: MaterialButton(
                          onPressed: () {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rool : ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    DropdownButton<String>(
                      dropdownColor: Colors.blue[900],
                      isDense: true,
                      isExpanded: false,
                      iconEnabledColor: Colors.white,
                      focusColor: Colors.white,
                      items: options.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(
                            dropDownStringItem,
                            style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValueSelected) {
                        setState(() {
                          _currentItemSelected = newValueSelected!;
                          rool = newValueSelected;
                        });
                      },
                      value: _currentItemSelected,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  customFormFeild({
    controller,
    labelText,
    keyboardType,
    textInputAction,
    obscureText,
  }) {
    return Material(
      elevation: 2.0,
      shadowColor: black,
      borderRadius: BorderRadius.circular(5.0),
      color: white,
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


