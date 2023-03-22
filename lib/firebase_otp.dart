import 'package:firebase_auth/firebase_auth.dart';

void verifyEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    //Check if user is not verified
    if(!(user!.emailVerified)) {
      user.sendEmailVerification();
    }
  }

  void sendResetPassword() {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.sendPasswordResetEmail(
      email: user!.email.toString(),
    );
  }