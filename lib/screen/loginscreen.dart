import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:igclone/resources/authmethod.dart';
import 'package:igclone/util/color.dart';
import 'package:igclone/util/dimension.dart';
import 'package:igclone/util/utils.dart';
import 'package:image_picker/image_picker.dart';

final firebase = FirebaseAuth.instance;
final storage = FirebaseStorage.instance;

class loginscreen extends StatefulWidget {
  const loginscreen({super.key});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  bool islogin = true;
  Uint8List? selectedimage;
  String bio = '';
  String email = '';
  String username = '';
  String password = '';

  final formkey = GlobalKey<FormState>();

  void selectimage() async {
    selectedimage = await pickImage(ImageSource.camera);
    setState(() {});
  }

  void submit() async {
    bool isvalid = formkey.currentState!.validate();
    if (!isvalid || !islogin && selectedimage == null) {
      return;
    }

    formkey.currentState!.save();
    if (islogin) {
      AuthMethods().loginuser(email: email, password: password, ctx: context);
    } else {
      AuthMethods().signupuser(
          email: email,
          password: password,
          username: username,
          bio: bio,
          file: selectedimage!,
          ctx: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > websize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  SvgPicture.asset('assets/images/logo.svg',
                      color: Colors.white),
                  const SizedBox(height: 50),
                  if (!islogin)
                    InkWell(
                      onTap: () {
                        selectimage();
                      },
                      borderRadius: BorderRadius.circular(70),
                      child: selectedimage == null
                          ? const CircleAvatar(
                              radius: 70,
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 50,
                              ),
                            )
                          : CircleAvatar(
                              radius: 70,
                              backgroundImage: MemoryImage(selectedimage!),
                            ),
                    ),
                  const SizedBox(height: 30),
                  if (!islogin)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.trim().length < 4) {
                            return 'enter valid username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          username = value!;
                        },
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white10,
                          labelText: "Enter username",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value!;
                      },
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        labelText: "Enter E-mail",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'Password must be 6 character long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value!;
                      },
                      obscureText: true,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      obscuringCharacter: '?',
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        labelText: "Enter password",
                        border: OutlineInputBorder(gapPadding: 20),
                      ),
                    ),
                  ),
                  if (!islogin)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter valid bio';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          bio = value!;
                        },
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white10,
                          labelText: "Enter your bio",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      submit();
                      FocusScope.of(context).unfocus();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: Size(150, 30),
                    ),
                    child: islogin
                        ? const Text(
                            "Login",
                            style: TextStyle(fontSize: 15),
                          )
                        : const Text(
                            "Signup",
                            style: TextStyle(fontSize: 15),
                          ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      islogin = !islogin;
                      setState(
                        () {
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                    child: islogin
                        ? const Text(
                            "New User?",
                            style: TextStyle(fontSize: 15),
                          )
                        : const Text(
                            "Already have an account?",
                            style: TextStyle(fontSize: 15),
                          ),
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
