import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:new_reddit_clone/core/common/Error_text.dart';
import 'package:new_reddit_clone/core/common/Loader.dart';
import 'package:new_reddit_clone/core/common/Postcard.dart';
import 'package:new_reddit_clone/features/auth/controller/CommunityController.dart';
import 'package:new_reddit_clone/features/post/controller/addpostController.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(
        data: (commnuties) => ref.watch(userPostsProvider(commnuties)).when(
            data: (data) {
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = data[index];
                    return PostCard(post: post);
                  });
            },
            error: (error, stackTrace) {
              print(error);
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader()),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
