import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_reddit_clone/core/enum/enum.dart';
import 'package:new_reddit_clone/core/modules/Community_Model.dart';
import 'package:new_reddit_clone/core/modules/comments.dart';
import 'package:new_reddit_clone/core/modules/postModels.dart';
import 'package:new_reddit_clone/core/utils.dart';
import 'package:new_reddit_clone/features/auth/controller/AuthController.dart';

import 'package:new_reddit_clone/features/auth/providers/storage_repositry_provider.dart';
import 'package:new_reddit_clone/features/post/repository/addrepository.dart';
import 'package:new_reddit_clone/user_profile/controller/userProfileController.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final PostControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);

  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
      storageRepository: storageRepository,
      postRepository: postRepository,
      ref: ref);
});

final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postcontroller = ref.watch(PostControllerProvider.notifier);
  return postcontroller.fetchUserData(communities);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postcontroller = ref.watch(PostControllerProvider.notifier);
  return postcontroller.getPostById(postId);
});

final getPostByCommentsProvider = StreamProvider.family((ref, String postId) {
  final postcontroller = ref.watch(PostControllerProvider.notifier);
  return postcontroller.fetchPostComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController({
    required Ref ref,
    required PostRepository postRepository,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost(
      {required BuildContext context,
      required String titel,
      required Community selectedCommunity,
      required String description}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
        id: postId,
        title: titel,
        description: description,
        communityName: selectedCommunity.name,
        communityProfile: selectedCommunity.avater,
        uid: user.uid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        upvotes: [],
        downvotes: [],
        username: '',
        commentCount: 0);

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textpost);

    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted successfully!');
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost(
      {required BuildContext context,
      required String titel,
      required Community selectedCommunity,
      required String link}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
        id: postId,
        link: link,
        title: titel,
        communityName: selectedCommunity.name,
        communityProfile: selectedCommunity.avater,
        uid: user.uid,
        type: 'link',
        createdAt: DateTime.now(),
        awards: [],
        upvotes: [],
        downvotes: [],
        username: '',
        commentCount: 0);

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkpost);

    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted successfully!');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost(
      {required BuildContext context,
      required String titel,
      required Community selectedCommunity,
      required File? file}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final storageRes = await _storageRepository.storeFile(
        path: 'posts/${selectedCommunity.name}', ID: postId, file: file);

    storageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
          id: postId,
          link: r,
          title: titel,
          communityName: selectedCommunity.name,
          communityProfile: selectedCommunity.avater,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          upvotes: [],
          downvotes: [],
          username: '',
          commentCount: 0);

      final res = await _postRepository.addPost(post);
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.imagePost);

      state = false;

      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserData(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserData(communities);
    }
    return Stream.value([]);
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);
    res.fold(
        (l) => null, (r) => showSnackBar(context, 'Post Deleted successfully'));
  }

  void upvote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, uid);
  }

  void downvote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, uid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required Post postId,
  }) async {
    final user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();
    Comments comment = Comments(
        id: commentId,
        text: text,
        postId: postId.id,
        username: user.name,
        createdAt: DateTime.now(),
        profilePic: user.profilePic);
    final res = await _postRepository.addComment(comment);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Stream<List<Comments>> fetchPostComments(String postId) {
    return _postRepository.getCommentsofOst(postId);
  }

  void awardPost({
    required Post post,
    required String award,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;
    final res = await _postRepository.awardPost(post, award, user.uid);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.awardPost);
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
      Routemaster.of(context).pop();
    });
  }
}
