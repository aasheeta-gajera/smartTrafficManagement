import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttrafficmanagement/Authentication/Register.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _sendOtpLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    try {
      final ActionCodeSettings acs = ActionCodeSettings(
        url: 'https://smarttrafficmanagementsy-3f635.firebaseapp.com', // 🔁 Use your Firebase Dynamic Link
        handleCodeInApp: true,
        androidPackageName: 'com.example.smarttrafficmanagement',
        androidInstallApp: true,
        androidMinimumVersion: '21',
      );

      await _auth.sendSignInLinkToEmail(email: email, actionCodeSettings: acs);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('emailForSignIn', email);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OTPPage()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to $email')),
      );
    } catch (e) {
      print('Send OTP error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Enter your email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendOtpLink,
              child: Text('Send OTP Link to Email'),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
