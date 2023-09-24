// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_reddit_clone/core/common/Error_text.dart';
import 'package:new_reddit_clone/core/common/Loader.dart';
import 'package:new_reddit_clone/core/constants/constants.dart';

import 'package:new_reddit_clone/core/modules/postModels.dart';
import 'package:new_reddit_clone/features/auth/controller/AuthController.dart';
import 'package:new_reddit_clone/features/auth/controller/CommunityController.dart';
import 'package:new_reddit_clone/features/post/controller/addpostController.dart';
import 'package:new_reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletepost(WidgetRef ref, BuildContext context) {
    ref.read(PostControllerProvider.notifier).deletePost(post, context);
  }

  void Upvotepost(WidgetRef ref) {
    ref.read(PostControllerProvider.notifier).upvote(post);
  }

  void downvotepost(WidgetRef ref) {
    ref.read(PostControllerProvider.notifier).upvote(post);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateTocommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateTocomments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  void awardsPost(WidgetRef ref, String award, BuildContext context) async {
    ref
        .read(PostControllerProvider.notifier)
        .awardPost(post: post, award: award, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeimage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(color: currentTheme.drawerTheme.backgroundColor),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                            .copyWith(right: 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => navigateTocommunity(context),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(post.communityProfile),
                                radius: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'r/${post.communityName}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () => navigateToUser(context),
                                    child: Text(
                                      'u/${post.username}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 180,
                            ),
                            if (post.uid == user.uid)
                              IconButton(
                                onPressed: () => deletepost(ref, context),
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                          ],
                        ),
                        if (post.awards.isNotEmpty) ...[
                          SizedBox(
                            height: 5,
                            child: SizedBox(
                              height: 25,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.awards.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final award = post.awards[index];
                                  return Image.asset(
                                    Constants.awards[award]!,
                                    height: 23,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                post.title,
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        if (isTypeimage)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: double.infinity,
                            child: Image.network(
                              post.link!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (isTypeLink)
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: AnyLinkPreview(
                                link: post.link!,
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                              )),
                        if (isTypeText)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  post.title,
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => Upvotepost(ref),
                              icon: Icon(
                                Icons.arrow_upward,
                                size: 30,
                                color: post.upvotes.contains(user.uid)
                                    ? Pallete.redColor
                                    : null,
                              )),
                          Text(
                            '${post.upvotes.length - post.downvotes.length == 0 ? 'Votes' : post.upvotes.length - post.downvotes.length}',
                            style: TextStyle(fontSize: 10),
                          ),
                          IconButton(
                              onPressed: () => downvotepost(ref),
                              icon: Icon(
                                Icons.arrow_downward,
                                size: 30,
                                color: post.downvotes.contains(user.uid)
                                    ? Pallete.redColor
                                    : null,
                              )),
                        ],
                      ),
                      SizedBox(
                        width: 70,
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => navigateTocomments(context),
                              icon: Icon(
                                Icons.comment,
                                size: 30,
                              )),
                          Text(
                            '${post.commentCount == 0 ? 'comment' : post.commentCount}',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      ref
                          .watch(getCommunityByNameProvider(post.communityName))
                          .when(
                              data: (data) {
                                if (data.mods.contains(user.uid)) {
                                  return IconButton(
                                      onPressed: () => deletepost(ref, context),
                                      icon: Icon(
                                        Icons.admin_panel_settings,
                                        size: 30,
                                      ));
                                }
                                return const SizedBox();
                              },
                              loading: () => const Loader(),
                              error: (error, stakeTrace) =>
                                  ErrorText(error: error.toString())),

// This code snippet creates an icon button with a comment icon, and sets the size of the icon to 30. The button has an empty onPressed function.
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: GridView.builder(
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4),
                                              itemCount: user.awards.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final award =
                                                    user.awards[index];
                                                return GestureDetector(
                                                  onTap: () => awardsPost(
                                                      ref, award, context),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Image.asset(Constants
                                                        .awards[award]!),
                                                  ),
                                                );
                                              })),
                                    ));
                          },
                          icon: Icon(
                            Icons.card_giftcard_outlined,
                            size: 30,
                          )),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
