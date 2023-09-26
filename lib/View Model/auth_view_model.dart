// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class AuthViewModel extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   User? _user;
//   User? get user => _user;
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   AuthNotifier() {
//     _auth.authStateChanges().listen((user) {
//       _user = user;
//       _isLoading = false;
//       notifyListeners();
//     });
//   }
//
//   Future<void> signInWithGoogle() async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
//       if (googleSignInAccount != null) {
//         final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );
//         await _auth.signInWithCredential(credential);
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }