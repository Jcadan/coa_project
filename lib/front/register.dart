import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:coa_project/front/Login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

bool passwordVisible = true;
bool passwordVisible1 = true;

class Register extends StatefulWidget {
  const Register({
    super.key,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _regUsernameController = TextEditingController();
  final TextEditingController _regEmailController = TextEditingController();
  final TextEditingController _regPasswordController = TextEditingController();
  final TextEditingController _regConfirmPasswordController =
      TextEditingController();

  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  Future<void> registrationUser() async {
    try {
      String uri = "http://192.168.100.19/api/register.php";

      var response = await http.post(Uri.parse(uri), body: {
        "username": _regUsernameController.text,
        "email": _regEmailController.text,
        "password": _regPasswordController.text
      });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['success'] == 1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 5),
                    Text('Success'),
                  ],
                ),
                content: const Text('Registered Successfully'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.to(const Login());
                    },
                  ),
                ],
              );
            },
          );
        } else if (data['success'] == 0) {
          setState(() {
            if (data['message'] == 'Username already exists') {
              _usernameError = "Username already exists";
            }
            if (data['message'] == 'Email already exists') {
              _emailError = "Email already exists";
            }
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Registration failed: ${data['message']}'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('Failed to insert data: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _regUsernameController.addListener(() {
      if (_usernameError != null && _regUsernameController.text.isNotEmpty) {
        setState(() {
          _usernameError = null;
        });
      }
    });

    _regEmailController.addListener(() {
      if (_emailError != null && _regEmailController.text.isNotEmpty) {
        setState(() {
          _emailError = null;
        });
      }
    });

    _regPasswordController.addListener(() {
      if (_passwordError != null && _regPasswordController.text.isNotEmpty) {
        setState(() {
          _passwordError = null;
        });
      }
    });

    _regConfirmPasswordController.addListener(() {
      if (_confirmPasswordError != null &&
          _regConfirmPasswordController.text.isNotEmpty) {
        setState(() {
          _confirmPasswordError = null;
        });
      }
    });
  }

  void _validateField() {
    setState(() {
      final RegExp emailRegex =
          RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

      _usernameError =
          _regUsernameController.text.isEmpty ? 'This field is required' : null;
      _passwordError =
          _regPasswordController.text.isEmpty ? 'This field is required' : null;
      _confirmPasswordError = _regConfirmPasswordController.text.isEmpty
          ? 'This field is required'
          : null;

      if (_regPasswordController.text.isNotEmpty &&
          _regPasswordController.text != _regConfirmPasswordController.text) {
        _confirmPasswordError = 'Passwords did not match';
      }
      if (_regEmailController.text.isEmpty) {
        setState(() {
          _emailError = 'This field is required';
        });
        return;
      } else if (!emailRegex.hasMatch(_regEmailController.text)) {
        setState(() {
          _emailError = 'Please enter a valid email address';
        });
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xff4FC3F7),
                Color(0xff0277BD),
              ])),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text('Sign Up!',
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          TextFormField(
                            controller: _regUsernameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Username',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(179, 240, 240, 240),
                            ),
                          ),
                          Container(
                            height: 20,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              _usernameError ?? '',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _regEmailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              hintText: 'Email',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(179, 240, 240, 240),
                            ),
                          ),
                          Container(
                            height: 20,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              _emailError ?? '',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _regPasswordController,
                            obscureText: passwordVisible,
                            decoration: InputDecoration(
                              suffix: InkWell(
                                onTap: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                child: Icon(passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(179, 240, 240, 240),
                            ),
                          ),
                          Container(
                            height: 20,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              _passwordError ?? '',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _regConfirmPasswordController,
                            obscureText: passwordVisible1,
                            decoration: InputDecoration(
                              suffix: InkWell(
                                onTap: () {
                                  setState(() {
                                    passwordVisible1 = !passwordVisible1;
                                  });
                                },
                                child: Icon(passwordVisible1
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Confirm Password',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(179, 240, 240, 240),
                            ),
                          ),
                          Container(
                            height: 20,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              _confirmPasswordError ?? '',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 15),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          GestureDetector(
                            onTap: () {
                              _validateField();
                              if (_formKey.currentState!.validate() &&
                                  _usernameError == null &&
                                  _emailError == null &&
                                  _passwordError == null &&
                                  _confirmPasswordError == null) {
                                registrationUser();
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 55,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: const LinearGradient(colors: [
                                      Color(0xff4FC3F7),
                                      Color(0xff0277BD),
                                    ]),
                                  ),
                                  child: const Center(
                                      child: Text('Register',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white))),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(const Login());
                                  },
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ));
  }
}
