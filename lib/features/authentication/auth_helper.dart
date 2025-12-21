import 'dart:async';

import 'package:bookapin/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  final firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  final clientId =
      '1074730233614-iqq8fur2eq3ciff7q36hlk0rrjasuipc.apps.googleusercontent.com';
  final serverClientId =
      '1074730233614-7mtg016fsqeo3925fk4m7vfnpl328hpc.apps.googleusercontent.com';

  Future<Users> signUpWithEmailUsernameAndPassword(
    String username,
    String email,
    String password,
  ) async {
    final UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    final docRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    await docRef.set({
      'username': username,
      'email': email,
      'role': 'Customer', 
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final doc = await docRef.get();
    return Users.fromFirestore(doc);
  }

  Future<Users> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final userCredential = await firebaseAuth
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        );

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    if (!doc.exists) {
      throw Exception('User tidak ditemukan di database');
    }

    return Users.fromFirestore(doc);
  }


  Future<Users> signInWithGoogle() async {
    unawaited(
      googleSignIn.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
      ),
    );

    final googleUser = await googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await firebaseAuth.signInWithCredential(credential);

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    if (!doc.exists) {
      throw Exception('User tidak ditemukan di database');
    }

    return Users.fromFirestore(doc);
  }


  Stream<User?> checkUserSignInState() {
    final state = firebaseAuth.authStateChanges();
    return state;
  }

  signOut() {
    googleSignIn.signOut();
    firebaseAuth.signOut();
  }
}