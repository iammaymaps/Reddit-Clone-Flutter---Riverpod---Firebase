import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:new_reddit_clone/core/Failure.dart';
import 'package:new_reddit_clone/core/constants/firebase_constants.dart';
import 'package:new_reddit_clone/core/modules/Community_Model.dart';
import 'package:new_reddit_clone/core/modules/postModels.dart';
import 'package:new_reddit_clone/core/type_def.dart';
import 'package:new_reddit_clone/features/auth/providers/firebase_Provider.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserData(List<Community> communities) {
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
