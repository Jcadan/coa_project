import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _passwordError;
  String? _confirmPasswordError;

  Future<void> resetPassword() async {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Please enter a new password';
      });
      return;
    } else if (password.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      return;
    } else if (password != confirmPassword) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
      return;
    }

    try {
      var response = await http.post(
        Uri.parse(
            "http://192.168.100.19/api/reset_password.php?token=${widget.token}"),
        body: {
          "new_password": password,
          "confirm_password": confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['success'] == 1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Password reset successfully!'),
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
        } else {
          setState(() {
            _passwordError = data['message'];
          });
        }
      } else {
        print('Failed to reset password');
      }
    } catch (e) {
      print(e);
      setState(() {
        _passwordError = 'An error occurred. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                errorText: _passwordError,
              ),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                errorText: _confirmPasswordError,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetPassword,
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
// if (email.isEmpty) {
    //   setState(() {
    //     _emailError = 'Please enter your email';
    //   });
    //   return;
    // } else if (!emailRegex.hasMatch(email)) {
    //   setState(() {
    //     _emailError = 'Please enter a valid email address';
    //   });
    //   return;
    // }