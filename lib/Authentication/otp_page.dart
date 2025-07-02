import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/Home.dart';

class OTPPage extends StatefulWidget {
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _verifying = true;
  String _status = "Verifying OTP...";

  @override
  void initState() {
    super.initState();
    _verifyLink();
  }

  Future<void> _verifyLink() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('emailForSignIn');
      final link = Uri.base.toString();

      if (_auth.isSignInWithEmailLink(link) && email != null) {
        await _auth.signInWithEmailLink(email: email, emailLink: link);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        setState(() {
          _status = "Invalid or expired OTP link";
          _verifying = false;
        });
        print("Verifying link: $link");
        print("Stored email: $email");
        print("isSignInWithEmailLink: ${_auth.isSignInWithEmailLink(link)}");

      }
    } catch (e) {
      setState(() {
        _status = "Failed to verify OTP: $e";
        _verifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _verifying
            ? CircularProgressIndicator()
            : Text(_status, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
