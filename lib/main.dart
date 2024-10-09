import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PhoneAuthScreen(),
      ),
    );
  }
}

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto verification success
        await _auth.signInWithCredential(credential);
        print('success');
        // Handle successful login here
      },
      verificationFailed: (FirebaseAuthException e) {
        print('success coming');

        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Verification failed: ${e.message}"),
        ));
      },
      codeSent: (String verificationId, int? resendToken) {
        // Code sent to user's phone
        setState(() {
          _verificationId = verificationId;
          print('codeSent $_verificationId');

        });
        print('codeSent');

      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout
        print('codeAutoRetrievalTimeout');

      },
    );
  }

  void _verifyOtp() async {
    String smsCode = _otpController.text.trim();
    if (_verificationId != null) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      try {
        await _auth.signInWithCredential(credential);
        // Handle successful login
        print('super success');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Phone number verified successfully!"),
        ));
      } catch (e) {
        print('super success on the way $e');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to sign in: ${e.toString()}"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Authentication")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _verifyPhoneNumber,
              child: Text("Verify Number"),
            ),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: "Enter OTP"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}

