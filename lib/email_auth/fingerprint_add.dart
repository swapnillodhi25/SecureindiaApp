import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:local_auth_windows/local_auth_windows.dart';
import 'package:demo/email_auth/user_details.dart';
import 'package:demo/email_auth/congratulations.dart';
import 'package:lottie/lottie.dart';



class SetFingerprintPage extends StatelessWidget {

  LocalAuthentication authentication = LocalAuthentication();
  Future<bool> authenticate() async {
    final bool isBiometricAvailable = await authentication.isDeviceSupported();
    if (!isBiometricAvailable) return false;
    try {
      return await authentication.authenticate(
        localizedReason: "Authenticate to view your secret",
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      // Log or handle the error, and then return false
      print("Authentication error: $e");
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Your Fingerprint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle at the top
            SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                'Add a Fingerprint to Make your Account more Secure',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 400,child: Lottie.asset("assets/lottie/fing2.json"),),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                'Please Click on Continue to Get Started with Fingerprint Verification.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            // Skip and Continue Buttons
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip Button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Congratulation()),
                        );
                      },
                      child: Text('Skip'),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    // Continue Button
                    Container(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () async {
                            bool isAuthenticated = await authenticate();
                            if (isAuthenticated) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => const Congratulation()),
                                ),
                              );
                            } else {
                              SizedBox();
                            }
                          },

                      child: const Text('Continue')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}