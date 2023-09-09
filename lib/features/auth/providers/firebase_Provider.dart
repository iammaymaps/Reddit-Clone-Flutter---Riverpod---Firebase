import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Create a provider for FirebaseFirestore.
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// Create a provider for FirebaseAuth.
final authProvider = Provider((ref) => FirebaseAuth.instance);

// Create a provider for FirebaseStorage.
final storageProvider = Provider((ref) => FirebaseStorage.instance);

// Create a provider for GoogleSignIn.
final googlesigninProvider = Provider((ref) => GoogleSignIn());
