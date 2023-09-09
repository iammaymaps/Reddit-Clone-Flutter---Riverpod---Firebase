import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_reddit_clone/core/Failure.dart';
import 'package:new_reddit_clone/core/constants/constants.dart';
import 'package:new_reddit_clone/core/constants/firebase_constants.dart';
import 'package:new_reddit_clone/core/modules/User_Models.dart';
import 'package:new_reddit_clone/core/type_def.dart';
import 'package:new_reddit_clone/features/auth/providers/firebase_Provider.dart';
import 'package:riverpod/riverpod.dart';

// Define a provider for the auth repository
final authRepositoryProvider = Provider((ref) => AuthRepository(
      firestore: ref.read(firestoreProvider),
      auth: ref.read(authProvider),
      googleSignIn: ref.read(googlesigninProvider),
    ));

// AuthRepository class responsible for handling authentication logic
class AuthRepository {
  final FirebaseAuth _auth; // Firebase authentication instance
  final FirebaseFirestore _firebaseFirestore; // Firestore database instance
  final GoogleSignIn _googleSignIn; // Google Sign-In instance

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firebaseFirestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Method to sign in with Google
  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signIn(); // Prompt user to select a Google account

      final googleAuth = await googleUser
          ?.authentication; // Get authentication details from selected Google account

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      ); // Create Google credentials using the obtained tokens

      // Sign in to Firebase using the Google credentials

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            name: userCredential.user!.displayName ?? "No name",
            profilePic:
                userCredential.user!.photoURL ?? Constants.avatarDefault,
            banner: Constants.bannerDefault,
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            karma: 0,
            awards: []);
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);

      // Print the signed-in user's email
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));

      // Re-throw the error to handle it elsewhere if needed// Print any error that occurred during sign-in
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
