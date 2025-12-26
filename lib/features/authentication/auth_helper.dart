import 'dart:async';

import 'package:bookapin/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
      final googleProvider = GoogleAuthProvider();

      final UserCredential result =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);

      final User firebaseUser = result.user!;
      final uid = firebaseUser.uid;

      final usersRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      final doc = await usersRef.get();

      if (!doc.exists) {
        await usersRef.set({
          'username': firebaseUser.displayName ?? '',
          'email': firebaseUser.email,
          'role': 'Customer',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      final savedDoc = await usersRef.get();
      return Users.fromFirestore(savedDoc);
    }


    Stream<User?> checkUserSignInState() {
      final state = firebaseAuth.authStateChanges();
      return state;
    }

  signOut() async {
    final user = firebaseAuth.currentUser;

    if (user != null) {
      final isGoogleUser = user.providerData.any(
        (p) => p.providerId == 'google.com',
      );

      if (isGoogleUser) {
        if (kIsWeb) {
          await googleSignIn.signOut();
        } else {
          await googleSignIn.disconnect();
        }
      }
    }

    await firebaseAuth.signOut();
  }
}