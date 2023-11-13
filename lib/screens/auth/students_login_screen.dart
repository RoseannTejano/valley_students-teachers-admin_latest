import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:valley_students_and_teachers/services/add_user.dart';
import 'package:valley_students_and_teachers/widgets/textfield_widget.dart';
import 'package:valley_students_and_teachers/widgets/toast_widget.dart';

import '../../utils/routes.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';

class StudentsLoginScreen extends StatefulWidget {
  const StudentsLoginScreen({super.key});

  @override
  State<StudentsLoginScreen> createState() => _StudentsLoginScreenState();
}

class _StudentsLoginScreenState extends State<StudentsLoginScreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 0, 47, 53),
          image: DecorationImage(
            opacity: 200,
            image: AssetImage(
              'assets/images/back.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 500,
                    ),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 200,
                        ),
                        TextFieldWidget(
                            label: 'Email', controller: emailcontroller),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                            isObscure: true,
                            isPassword: true,
                            label: 'Password',
                            controller: passwordcontroller),
                        Padding(
                          padding: const EdgeInsets.only(left: 200),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: ((context) {
                                    final formKey = GlobalKey<FormState>();
                                    final TextEditingController
                                        emailControllernew =
                                        TextEditingController();

                                    return AlertDialog(
                                      backgroundColor: Colors.grey[100],
                                      title: TextRegular(
                                        text: 'Forgot Password',
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      content: Form(
                                        key: formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFieldWidget(
                                              hint: 'Email',
                                              inputType:
                                                  TextInputType.emailAddress,
                                              label: 'Email',
                                              controller: emailControllernew,
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: (() {
                                            Navigator.pop(context);
                                          }),
                                          child: TextRegular(
                                            text: 'Cancel',
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: (() async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              try {
                                                Navigator.pop(context);
                                                await FirebaseAuth.instance
                                                    .sendPasswordResetEmail(
                                                        email:
                                                            emailControllernew
                                                                .text);
                                                showToast(
                                                    'Password reset link sent to ${emailControllernew.text}');
                                              } catch (e) {
                                                String errorMessage = '';

                                                if (e is FirebaseException) {
                                                  switch (e.code) {
                                                    case 'invalid-email':
                                                      errorMessage =
                                                          'The email address is invalid.';
                                                      break;
                                                    case 'user-not-found':
                                                      errorMessage =
                                                          'The user associated with the email address is not found.';
                                                      break;
                                                    default:
                                                      errorMessage =
                                                          'An error occurred while resetting the password.';
                                                  }
                                                } else {
                                                  errorMessage =
                                                      'An error occurred while resetting the password.';
                                                }

                                                showToast(errorMessage);
                                                Navigator.pop(context);
                                              }
                                            }
                                          }),
                                          child: TextBold(
                                            text: 'Continue',
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                );
                              },
                              child: TextRegular(
                                  text: 'Forgot Password?',
                                  fontSize: 12,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ButtonWidget(
                          fontColor: Colors.black,
                          radius: 100,
                          height: 60,
                          color: Colors.white,
                          label: 'Login',
                          onPressed: () {
                            final email = emailcontroller.text;
                            final password = passwordcontroller.text;
                            if (isValidEmail(email) &&
                                isValidPassword(password)) {
                              login();
                            } else {
                              showToast(
                                  'Invalid email and password combination!');
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ButtonWidget(
                          fontColor: Colors.black,
                          radius: 100,
                          height: 60,
                          color: Colors.white,
                          label: 'Signup',
                          onPressed: () {
                            registerDialog();
                          },
                        ),
                      ],
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

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  registerDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.white.withOpacity(0.8),
              child: Container(
                color: Colors.white.withOpacity(0.5),
                height: 375,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFieldWidget(
                          label: 'Full Name', controller: nameController),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                          label: 'Email', controller: emailController),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                          isPassword: true,
                          isObscure: true,
                          label: 'Password',
                          controller: passwordController),
                      const SizedBox(
                        height: 30,
                      ),
                      ButtonWidget(
                          color: Colors.black,
                          label: 'Register',
                          onPressed: (() async {
                            final email = emailController.text;
                            final password = passwordController.text;
                            if (isValidEmail(email) &&
                                isValidPassword(password)) {
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);
                                // addUser(
                                //     newNameController
                                //         .text,
                                //     newEmailController
                                //         .text,
                                //     newPassController
                                //         .text);
                                addUser(
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    'Student');
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: TextRegular(
                                        text: 'Account created succesfully!',
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: TextRegular(
                                        text: e.toString(),
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                );
                              }
                            } else {
                              showToast(
                                  'Invalid email and password combination!');
                            }
                          })),
                    ],
                  ),
                ),
              ));
        });
  }

  login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);

      Navigator.pushReplacementNamed(context, Routes().studenthomescreen);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextRegular(
              text: e.toString(), fontSize: 14, color: Colors.white),
        ),
      );
    }
  }

  bool isValidEmail(String email) {
    // Validate email using a regular expression for CSPC email format.

    if (email.contains('cspc')) {
      return true;
    } else {
      return false;
    }
  }

  bool isValidPassword(String password) {
    // Check if password has at least 8 characters and contains a combination of upper, lower, and a number.
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }
}
