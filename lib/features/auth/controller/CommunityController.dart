// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:new_reddit_clone/core/Failure.dart';
import 'package:new_reddit_clone/core/constants/constants.dart';
import 'package:new_reddit_clone/core/modules/Community_Model.dart';
import 'package:new_reddit_clone/core/modules/postModels.dart';
import 'package:new_reddit_clone/core/utils.dart';

import 'package:new_reddit_clone/features/Community/Community_Repository.dart';

import 'package:new_reddit_clone/features/auth/controller/AuthController.dart';
import 'package:new_reddit_clone/features/auth/providers/storage_repositry_provider.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final comunityController = ref.watch(CommunityControllerProvider.notifier);
  // final StorageRepository = ref.watch(storageRepositoryProvider);
  return comunityController.getUserCommunities();
});

final CommunityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(CommunityRepositoryProvider);

  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
      storageRepository: storageRepository,
      communityRepository: communityRepository,
      ref: ref);
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(CommunityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(CommunityControllerProvider.notifier).searchCommunity(query);
});

final getCommunityPostProvider = StreamProvider.family((ref, String name) {
  return ref.read(CommunityControllerProvider.notifier).getCommunityPost(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;

  final StorageRepository _storageRepository;

  CommunityController({
    required StorageRepository storageRepository,
    required CommunityRepository communityRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> res;

    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }
  }

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avater: Constants.avatarDefault,
        members: [uid],
        mods: [uid]);
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommnitys(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(
      {required File? profileFile,
      required File? bannerFile,
      required BuildContext context,
      required Community community}) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/profile', ID: community.name, file: profileFile);

      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(avater: r));
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/banner', ID: community.name, file: bannerFile);

      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(banner: r));
    }

    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void addmods(
      String communityname, List<String> uids, BuildContext context) async {
    final res = await _communityRepository.addMods(communityname, uids);
    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }

  Stream<List<Post>> getCommunityPost(String name) {
    return _communityRepository.getCommunityPosts(name);
  }
}
