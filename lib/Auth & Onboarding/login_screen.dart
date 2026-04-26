import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import '../services/database_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static String? savedUsername;

  Future<String?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return "تم إلغاء التسجيل";

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      await _saveSocialUserToFirestore(userCredential.user);
      return null;
    } catch (e) {
      return "خطأ في جوجل: $e";
    }
  }

  Future<String?> _signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        await _saveSocialUserToFirestore(userCredential.user);
        return null;
      }
      return "فشل تسجيل الدخول بفيسبوك: ${result.message}";
    } catch (e) {
      return "خطأ في فيسبوك: $e";
    }
  }

  Future<void> _saveSocialUserToFirestore(User? user) async {
    if (user != null) {
      final DatabaseService db = DatabaseService();
      savedUsername = user.displayName;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!userDoc.exists) {
        await db.saveUser(
          UserModel(
            uid: user.uid,
            name: user.displayName ?? "User",
            email: user.email ?? "",
            major: "Educational Technology",
          ),
        );
      } else {
        savedUsername = userDoc.data()?['name'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.height < 700;

    return Scaffold(
      body: SafeArea(
        child: FlutterLogin(
          title: 'Zeroin',
          logo: const AssetImage('assets/image/logoo.png'),
          onLogin: (loginData) async {
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: loginData.name,
                password: loginData.password,
              );
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get();
              savedUsername =
                  userDoc.data()?['name'] ?? loginData.name.split('@')[0];
              return null;
            } on FirebaseAuthException catch (e) {
              return e.message;
            }
          },
          onSignup: (signupData) async {
            try {
              UserCredential credential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                    email: signupData.name!,
                    password: signupData.password!,
                  );
              if (credential.user != null) {
                String fullName =
                    signupData.additionalSignupData?['username'] ?? "User";
                await db.saveUser(
                  UserModel(
                    uid: credential.user!.uid,
                    name: fullName,
                    email: signupData.name!,
                    major: "Educational Technology",
                  ),
                );
                savedUsername = fullName;
              }
              return null;
            } on FirebaseAuthException catch (e) {
              return e.message;
            } catch (e) {
              return "حدث خطأ أثناء حفظ البيانات: $e";
            }
          },
          additionalSignupFields: [
            const UserFormField(
              keyName: 'username',
              displayName: 'Full Name',
              icon: Icon(Icons.person_outline, color: Color(0xFF8486BA)),
            ),
          ],
          loginProviders: [
            LoginProvider(
              icon: FontAwesomeIcons.google,
              label: 'Google',
              callback: _signInWithGoogle,
            ),
            LoginProvider(
              icon: FontAwesomeIcons.facebook,
              label: 'Facebook',
              callback: _signInWithFacebook,
            ),
          ],
          onSubmitAnimationCompleted: () {
            // التعديل: الذهاب للأورينتيشن بدلاً من التراكس
            Navigator.of(context).pushReplacementNamed('/ai_orientation');
          },
          onRecoverPassword: (name) async {
            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
              return null;
            } catch (e) {
              return "Error sending reset email";
            }
          },
          theme: LoginTheme(
            primaryColor: const Color(0xFF787BB3),
            accentColor: Colors.white,
            logoWidth: isSmallScreen ? 0.6 : 0.75,
            titleStyle: TextStyle(
              fontSize: isSmallScreen ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            buttonTheme: LoginButtonTheme(
              backgroundColor: const Color(0xFF6265AC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            inputTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: EdgeInsets.symmetric(
                vertical: size.height * 0.018,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
