import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import 'package:projet_final/view/login_page.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email.toLowerCase(), password: password);
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.toLowerCase(), password: password);
  }

  Future<void> createUserWithEmailAndPasswordAndAddToDB({
    required String email,
    required String password,
    required int numDossier,
    required String institution,
    required String nom,
    required String prenom,
    required String photo,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: email.toLowerCase(), password: password);
      User? user = userCredential.user;
      if (user != null) {
        // Add email to the database
        addUserToDatabase(user.uid, email, password, numDossier, institution,
            nom, prenom, photo); // Implement this function if not done yet
      } else {
        // Handle case when user is null (which should be rare)
        throw Exception("User creation successful, but user is null.");
      }
    } catch (error) {
      // Handle the errors here
      if (kDebugMode) {
        print("Error creating user: $error");
      }
    }
  }

  //SAVING DATA IN THE DATABASE AFTER CREATION
  Future<void> addUserToDatabase(
      String userId,
      String email,
      String password,
      int numDossier,
      String institution,
      String nom,
      String prenom,
      String photo) async {
    try {
      await FirebaseFirestore.instance.collection('student').doc(userId).set({
        'email': email.toLowerCase(),
        'numDossier': numDossier,
        'institution': institution,
        'nom': nom,
        'prenom': prenom,
        'photo': photo,
      });
    } catch (e) {
      // Gérer les erreurs ici
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}


class SignOut extends StatelessWidget {
  SignOut({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> handleSignOut() async {
    await Auth().signOut();
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Widget _title() {
    return const Text("Firebase Auth");
  }

  Widget _userUID() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        handleSignOut().then((_) => _navigateToLoginPage(context));
      },
      child: const Text("Sign out"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUID(),
            _signOutButton(context),
          ],
        ),
      ),
    );
  }
}
